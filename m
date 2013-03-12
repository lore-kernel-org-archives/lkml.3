Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932843Ab3CLLbK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 07:31:10 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:61923 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932183Ab3CLLbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 07:31:07 -0400
MIME-Version: 1.0
In-Reply-To: <513F0EC8.60709@cogentembedded.com>
References: <1363073281-9939-1-git-send-email-silviupopescu1990@gmail.com>
	<513F0EC8.60709@cogentembedded.com>
Date: Tue, 12 Mar 2013 13:31:06 +0200
Message-ID: <CAPWTe+JGm07zp62EZCzPYGvorrZHLoS6Nz0WORv-o56zdCfudQ@mail.gmail.com>
Subject: Re: [PATCH v2] pci: convert to devm_ioremap_resource()
From: Silviu Popescu <silviupopescu1990@gmail.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org, juhosg@openwrt.org,
        blogic@openwrt.org, kaloz@openwrt.org, xsecute@googlemail.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 1:17 PM, Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com> wrote:
> Hello.
>
>
> On 12-03-2013 11:28, Silviu-Mihai Popescu wrote:
>
>> Convert all uses of devm_request_and_ioremap() to the newly introduced
>> devm_ioremap_resource() which provides more consistent error handling.
>
>
>> devm_ioremap_resource() provides its own error messages so all explicit
>> error messages can be removed from the failure code paths.
>
>
>    There were no error messages as far as I could see, so this passage seems
> superfluous...

Sorry for that, I sent a refreshed version of the patch.

Thanks,
Silviu
