Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188AbaLIBim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 20:38:42 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:61232 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261AbaLIBik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 20:38:40 -0500
MIME-Version: 1.0
In-Reply-To: <20141209010803.GA30604@shangw>
References: <1418075552-26495-1-git-send-email-yinghai@kernel.org>
	<1418079372.13358.9.camel@kernel.crashing.org>
	<CAE9FiQX-vMu5+Kr09ngr95WvtoZTUSL5R2+NiVFeiN6q-BXLLg@mail.gmail.com>
	<20141209010803.GA30604@shangw>
Date: Mon, 8 Dec 2014 17:38:35 -0800
X-Google-Sender-Auth: FQ8pGQuk0K9oteGgAW5hc1e8hdk
Message-ID: <CAE9FiQWAF6hxwPoH6Gb_KczJ9-B=Aya9bJG2mz3nrSdGF7_NVg@mail.gmail.com>
Subject: Re: [PATCH] PCI: Clear bridge MEM_64 flag if one child does not
 support it
From: Yinghai Lu <yinghai@kernel.org>
To: Gavin Shan <gwshan@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?Q?Marek_Kord=C3=ADk?= <kordikmarek@gmail.com>,
        Alexey Voronkov <zermond@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 8, 2014 at 5:08 PM, Gavin Shan <gwshan@linux.vnet.ibm.com> wrote:
> On Mon, Dec 08, 2014 at 03:59:54PM -0800, Yinghai Lu wrote:
>
> Yinghai, With the patch, the Power8 machine boots up and have resources
> assigned properly: 64-bits pref BARs are covered by 64-bits pref windows
> and left memory BARs are covered by 32-bits non-pref windows. Note that
> I didn't find an 32-bits-pref BAR on the system.
>
> For SRIOV case, Richard still need test.

Good, Thanks for the testing.

Yinghai
