Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762789Ab3JQVA0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 17:00:26 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:36103 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762371Ab3JQVAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 17:00:25 -0400
MIME-Version: 1.0
In-Reply-To: <20131017112806.GA5293@intel.com>
References: <20130920203556.GA8726@www.outflux.net>
	<alpine.LRH.2.02.1310171858170.32257@tundra.namei.org>
	<20131017112806.GA5293@intel.com>
Date: Thu, 17 Oct 2013 14:00:24 -0700
X-Google-Sender-Auth: -j2eht7nHLNtC4qQqczXnGojm8s
Message-ID: <CAGXu5j+OJZFQxmuGtpcEakNMTVfcP8kSPoC4R9Yu6_eYLk2T-g@mail.gmail.com>
Subject: Re: [PATCH] LSM: ModPin LSM for module loading restrictions
From: Kees Cook <keescook@chromium.org>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: James Morris <jmorris@namei.org>, LKML <linux-kernel@vger.kernel.org>,
        James Morris <james.l.morris@oracle.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        linux-security-module <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 4:30 AM, Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
> On Thu, Oct 17, 2013 at 07:02:17PM +1100, James Morris wrote:
>> This seems like a regression in terms of separating mechanism and policy.
>>
>> We have several access control systems available (SELinux, at least) which
>> can implement this functionality with existing mechanisms using dynamic
>> policy.
>>
>> I'm concerned about the long term architectural impact of a proliferation
>> of arbitrary hard-coded security policies in the kernel.  I don't
>> understand the push in this direction, frankly.
>
> The biggest risk in LSM stacker is really to become backdoor for very product
> dilated kernel changes that are not accepted to the mainline kernel. I think
> having LSM stacker would be benefical but barrier should be set very high
> for "one-shot" modules.
>
> One big benefit that I see in LSM stacker is not at least directly security
> related. It would be perfect integration tool when you want for example
> provide Android run-time in an OS that uses AppArmor or SMACK as its security
> framework.

I think of stacking as a way to help people do quick prototyping of
security changes without getting in the way of their distro's MAC.

-Kees

-- 
Kees Cook
Chrome OS Security
