Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565AbaFENYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 09:24:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57607 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaFENYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 09:24:08 -0400
MIME-Version: 1.0
In-Reply-To: <CAPcyv4icNZU9s7zLYYcrFrNA_9qk4W1je42KKG+ETWqdoQu_kg@mail.gmail.com>
References: <CACVXFVMnM6w5ZLX=S8fJHeVoEqxH2JG3Wg=GPMeoVnOpAjsvAA@mail.gmail.com>
	<CAPcyv4icNZU9s7zLYYcrFrNA_9qk4W1je42KKG+ETWqdoQu_kg@mail.gmail.com>
Date: Thu, 5 Jun 2014 21:24:04 +0800
Message-ID: <CACVXFVPHfP1VXujLx9sGt3c7ptdG1JvBQkw2JiJQsU1KwJ1zog@mail.gmail.com>
Subject: Re: [Regression] commit 8a4aeec8d(libata/ahci: accommodate tag
 ordered controllers)
From: Ming Lei <ming.lei@canonical.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Tejun Heo <tj@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 5, 2014 at 9:12 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Thu, Jun 5, 2014 at 1:53 AM, Ming Lei <ming.lei@canonical.com> wrote:
>> Hi Dan and Tejun,
>>
>> Looks the commit 8a4aeec8d(libata/ahci: accommodate tag ordered
>> controllers) causes below sata failure[1] on APM AHCI controller.
>>
>> And the error does disappear after reverting the commit.
>
> Can you give some more details about the workload and the disk?  What
> is the APM AHCI?

The commit causes the APM arm64 based system not bootable, and not
special workload, just when mounting rootfs or reading init files.

APM AHCI:
      drivers/ata/ahci_xgene.c

Thanks,
--
Ming Lei
