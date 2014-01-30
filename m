Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720AbaA3OKX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 09:10:23 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:60911 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338AbaA3OKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 09:10:18 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Tanmay Inamdar <tinamdar@apm.com>
Subject: Re: [RFC PATCH V3 2/4] arm64: dts: APM X-Gene PCIe device tree nodes
Date: Thu, 30 Jan 2014 15:09:25 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Landley <rob@landley.net>, linux-pci@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@apm.com, jcm@redhat.com
References: <1390599168-13150-1-git-send-email-tinamdar@apm.com> <1390599168-13150-3-git-send-email-tinamdar@apm.com>
In-Reply-To: <1390599168-13150-3-git-send-email-tinamdar@apm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201401301509.26080.arnd@arndb.de>
X-Provags-ID: V02:K0:PnuIwmQAhuE5oOTTArVcRIanE7KulBRHrmhRgJU1k0G
 7lTYlCZd3NGHq/iwO7+uFW+TkKCcavBPWoAMYybCAWWHZX7Yh+
 hlTt9DbPfd9kyY9HnHT9dVmkBhSa54URrJeamrYOQBcikmB0/X
 psFgmkQdUgNYBOFhqpqz1pmWBQTbmJ99jsD16oSliPFdLMTPXs
 39UmVE94Oq0ttpU4qBAN027x1tAt9Tf3hlvyQPfOX2ohdG/EFr
 FpTbZPz4u1wGZbYV6+ntrWGbi2wc9Belc7Wg5TmEeW7maR/K9d
 3baTA3NycspqBLRIc+Fv2qxvf1P12tmjGUlq6cOTZELHXpjiKW
 q+SX3AfLKcj2aFNFD/Kw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 January 2014, Tanmay Inamdar wrote:
> +               pcie3: pcie@1f500000 {
> +                       reg-names = "csr", "cfg";
> +                       ranges = <0x01000000 0x0 0x00000000 0xa0 0x00000000 0x0 0x00010000  /* mem */
> +                                 0x02000000 0x0 0x10000000 0xa0 0x10000000 0x0 0x80000000>; /* io  */

The two comments are wrong for this instance.

	Arnd
