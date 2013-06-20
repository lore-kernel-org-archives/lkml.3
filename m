Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935504Ab3FTBe4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 21:34:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39093 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935237Ab3FTBez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 21:34:55 -0400
MIME-Version: 1.0
In-Reply-To: <20130619143814.GB8413@kroah.com>
References: <20130619180027.ede041e59b1c642c7e5c603c@canb.auug.org.au>
	<20130619143814.GB8413@kroah.com>
Date: Thu, 20 Jun 2013 09:34:52 +0800
Message-ID: <CACVXFVOyarM8jAKPLchWVN1VdJERdH0k8e6rPJt+WWW7JofqEQ@mail.gmail.com>
Subject: Re: linux-next: build warning after merge of the final tree
 (driver-core tree related)
From: Ming Lei <ming.lei@canonical.com>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 10:38 PM, Greg KH <greg@kroah.com> wrote:
> On Wed, Jun 19, 2013 at 06:00:27PM +1000, Stephen Rothwell wrote:
>> Hi all,
>>
>> After merging the final tree, today's linux-next build (powerpc
>> allnoconfig among others) produced these warnings:
>>
>> drivers/base/firmware_class.c:1254:12: warning: 'cache_firmware' defined but not used [-Wunused-function]
>>  static int cache_firmware(const char *fw_name)
>>             ^
>> drivers/base/firmware_class.c:1281:12: warning: 'uncache_firmware' defined but not used [-Wunused-function]
>>  static int uncache_firmware(const char *fw_name)
>>             ^
>>
>> Revealed by commit 93232e46b209 ("firmware loader: don't export
>> cache_firmware and uncache_firmware") from the driver-core tree.  These
>> are only used if CONFIG_PM_SLEEP is set.
>
> Odd.  Ming, can you send me a patch for this?

No problem, will send you a patch together with the merge patch.

thanks,
--
Ming Lei
