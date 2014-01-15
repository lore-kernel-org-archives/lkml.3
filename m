Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726AbaAORjV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 12:39:21 -0500
Received: from exprod5og104.obsmtp.com ([64.18.0.178]:55301 "HELO
	exprod5og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752525AbaAORjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 12:39:18 -0500
MIME-Version: 1.0
In-Reply-To: <20140114160755.GC4307@srcf.ucam.org>
References: <1389135041-16062-1-git-send-email-fkan@apm.com>
	<20140114160755.GC4307@srcf.ucam.org>
Date: Wed, 15 Jan 2014 09:39:17 -0800
Message-ID: <CAL85gmC+OR_hR+jtsAdBSgMau7MnHZSqFpoR+VJ7dWNOGdfBXQ@mail.gmail.com>
Subject: Re: [PATCH V2 0/6] Enable X-Gene platform reboot driver.
From: Feng Kan <fkan@apm.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 8:07 AM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Tue, Jan 07, 2014 at 02:50:35PM -0800, Feng Kan wrote:
>> Enable X-Gene platform driver for the X-Gene platform. Remove the
>> use of the mask attribute from the reboot dts node. Add support
>> for using the ACPI and DTS resource for the reboot driver.
>
> Why can't you just use the standard ACPI reboot register values in the
> FADT?
>
FKAN: I am removing the acpi patch in the next round. Mainly, I don't see a
way for the arm64 kernel to use those values. EFI in x86 have some runtime
services that can be triggered to call reset_system, but that code is not
available yet in arm64.

> --
> Matthew Garrett | mjg59@srcf.ucam.org
