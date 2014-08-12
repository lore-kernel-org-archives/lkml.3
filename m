Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254AbaHLMlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 08:41:21 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:38892 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbaHLMlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 08:41:20 -0400
MIME-Version: 1.0
In-Reply-To: <s5hbnrpgah7.wl%tiwai@suse.de>
References: <1407845740-3524-1-git-send-email-sudipm.mukherjee@gmail.com>
	<s5hbnrpgah7.wl%tiwai@suse.de>
Date: Tue, 12 Aug 2014 18:11:19 +0530
Message-ID: <CADVatmObZZ+DkFsuyagD05f=LhobVP4u-7gC9LXr_UcDgV_TOg@mail.gmail.com>
Subject: Re: [PATCH] sound: pci: es1968: use pci_device_id
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: perex@perex.cz, alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 5:56 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Tue, 12 Aug 2014 17:45:40 +0530,
> Sudip Mukherjee wrote:
>>
>> Uses the struct pci_device_id instead of the depreciated macro DEFINE_PCI_DEVICE_TABLE.
>
> If we do this, better to apply to all sound/pci/* at once after
> 3.17-rc1 is released.
>
>
> thanks,
>
> Takashi

If we apply to all sound.pci/* , then it will be 69 replacements in
one go. If you all want that way , then will do it after 3.17-rc1 is
releases .

Thanks
Sudip
