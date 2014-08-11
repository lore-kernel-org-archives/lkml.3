Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614AbaHKRBa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 13:01:30 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:33042 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478AbaHKRB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 13:01:29 -0400
MIME-Version: 1.0
In-Reply-To: <53D9FADA.6020304@iam.tj>
References: <53D9FADA.6020304@iam.tj>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 11 Aug 2014 11:01:08 -0600
Message-ID: <CAErSpo4J6nNzhT6e7xf85+J_dDCht3V35HLAmc+zCPiA48MUMw@mail.gmail.com>
Subject: Re: Regression: pci=realloc fails to modify bridge windows, causing
 devices to fail BAR allocation
To: TJ <linux@iam.tj>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc linux-pci]

On Thu, Jul 31, 2014 at 2:14 AM, TJ <linux@iam.tj> wrote:
> See https://bugzilla.kernel.org/show_bug.cgi?id=81431
>
> Summary:
>
> Up until v3.15.7 booting with "pci=realloc,use_crs" successfully modifies
> the PCI bridge windows to allow an external ExpressCard <> ViDock4 + Nvidia
> Quadro NVS420 with its 2 GPUs to be configured.
>
> With v3.16rc6 and rc7 it fails to do this, leaving the NVS420 inoperable.

Thanks for the report and the dmesg logs.  I'm just returning from
vacation and haven't been able to analyze them yet.  If you have a
chance to bisect this to a specific commit, we might be able to fix or
revert it.

Bjorn
