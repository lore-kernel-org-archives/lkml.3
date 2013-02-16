Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab3BPHuN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 02:50:13 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:62874 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab3BPHuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 02:50:12 -0500
Date: Sat, 16 Feb 2013 11:50:08 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] kernel: arg2 is unsigned long which is never < 0
Message-ID: <20130216075008.GB20312@moon>
References: <511F0775.6030008@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <511F0775.6030008@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2013 at 12:13:41PM +0800, Chen Gang wrote:
> 
>   arg2 will never < 0, for its type is 'unsigned long'
> 
>   so need beautify the relative source code (better to use macros).
> 
> Reported-by: Cyrill Gorcunov <gorcunov@openvz.org>
> Signed-off-by: Chen Gang <gang.chen@asianux.com>

Looks good to me, thanks Chen!
