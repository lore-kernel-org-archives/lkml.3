Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359AbaB0OJn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 09:09:43 -0500
Received: from moutng.kundenserver.de ([212.227.17.13]:61087 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbaB0OJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 09:09:41 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linaro-kernel@lists.linaro.org
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, linux-pci <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 1/3] Fix ioport_map() for !CONFIG_GENERIC_IOMAP cases.
Date: Thu, 27 Feb 2014 15:09:28 +0100
Message-ID: <5331963.VjH27eqhpK@wuerfel>
User-Agent: KMail/4.11.3 (Linux/3.11.0-15-generic; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1393506599-11561-2-git-send-email-Liviu.Dudau@arm.com>
References: <1393506599-11561-1-git-send-email-Liviu.Dudau@arm.com> <1393506599-11561-2-git-send-email-Liviu.Dudau@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:kx43QQLy7jIVNtGhUnQlRfF7yu9EQqmq/8fiXUTsjXe
 STi2rwnI7/Ax2sXQT6wsfNxMHC6Ps9CeVzUiCRFQk9IfBBx/Dl
 Z9JgU11Hjj7oyBdYZvj8hm/6Xs8rMBTItIlZJ2A9MxgFEoDV0x
 UcZfATXCxQlp4hi4Vprjo7Ws3T6YNEk2jlpiPXSjhMykFhLQK7
 HPLFGMPlSp4+KgeluGigo4jUUfrxZOxpJ6xH77fGd1GPV3DV+i
 2nUtWxbfWq+zdahdJ75CKbtjG6LrIlQkLwPJDvKagscLqyMN7C
 7OJ4x8gn3b0qcMh/ce2R7eamEixfI9WImf2P3kxilNWPQeL9eZ
 +lJUyVe6VaralrLMKeiM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 February 2014 13:09:57 Liviu Dudau wrote:
> The inline version of ioport_map() that gets used when !CONFIG_GENERIC_IOMAP
> is wrong. It returns a mapped (i.e. virtual) address that can start from
> zero and completely ignores the PCI_IOBASE and IO_SPACE_LIMIT that most
> architectures that use !CONFIG_GENERIC_MAP define.
> 
> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> 
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>
