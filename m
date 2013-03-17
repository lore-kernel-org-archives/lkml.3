Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932733Ab3CQWgZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 18:36:25 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:48406 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755757Ab3CQWgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 18:36:24 -0400
MIME-Version: 1.0
X-Originating-IP: [109.186.17.83]
In-Reply-To: <CAOS58YNbSC3BcU9HbMyhNcrfkxQwDDLUk57Kk5byyvM2_oPAGg@mail.gmail.com>
References: <1362610608-64885-1-git-send-email-s-anna@ti.com> <CAOS58YNbSC3BcU9HbMyhNcrfkxQwDDLUk57Kk5byyvM2_oPAGg@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 18 Mar 2013 00:36:02 +0200
Message-ID: <CAK=Wgbb7xtFXf7i4F7gx6BHJiggR8Cq=zjauPb6enTnnrQjWrw@mail.gmail.com>
Subject: Re: [PATCH] remoteproc: fix the error check for idr_alloc
To: Tejun Heo <tj@kernel.org>
Cc: Suman Anna <s-anna@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 7, 2013 at 1:13 AM, Tejun Heo <tj@kernel.org> wrote:
> On Wed, Mar 6, 2013 at 2:56 PM, Suman Anna <s-anna@ti.com> wrote:
>> The new idr_alloc interface returns the allocated id back
>> on success, so fix the error path to check for negative
>> values. This was missed out in the newer idr interface
>> adoption patch, 15fc611 "remoteproc: convert to idr_alloc()".
>>
>> Signed-off-by: Suman Anna <s-anna@ti.com>
>> Cc: Tejun Heo <tj@kernel.org>
>> Cc: Ohad Ben-Cohen <ohad@wizery.com>
>
> Acked-by: Tejun Heo <tj@kernel.org>

Thanks Suman, applied to fixes.
