Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817Ab3F3I1n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 04:27:43 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:40680 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab3F3I1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 04:27:37 -0400
MIME-Version: 1.0
X-Originating-IP: [93.173.177.224]
In-Reply-To: <CAPgLHd8=VBbx6kvSTM9Ys2kFQC6mn=Xvr7Za-juFa=0hb7nLpw@mail.gmail.com>
References: <CAPgLHd8=VBbx6kvSTM9Ys2kFQC6mn=Xvr7Za-juFa=0hb7nLpw@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sun, 30 Jun 2013 11:27:15 +0300
Message-ID: <CAK=WgbbnoOBnP6ux9pcGMZk9dPJHLNCEPXjpB0k1s33ux5qJDA@mail.gmail.com>
Subject: Re: [PATCH] remoteproc: fix error return code in rproc_fw_boot()
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjur.brandeland@stericsson.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 9, 2013 at 5:02 AM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Fix to return -EINVAL in the rproc_find_loaded_rsc_table() error handling
> case instead of 0, as done elsewhere in this function.
>
> Introduced by commit a2b950ac7b1e6442919ee9e79c4963e134698869
> (remoteproc: perserve resource table data).
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Applying while fixing additional instances of this in the same function. Thanks!
