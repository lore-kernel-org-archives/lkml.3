Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbaLBKKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 05:10:23 -0500
Received: from mail.emea.novell.com ([130.57.118.101]:50039 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577AbaLBKKP convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Tue, 2 Dec 2014 05:10:15 -0500
Message-Id: <547D9E13020000780004C0B3@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Tue, 02 Dec 2014 10:10:11 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: <linux@eikelenboom.it>, <bhelgaas@google.com>,
        <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH v4] Fixes for PCI backend for 3.19
References: <1416608271-18931-1-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1416608271-18931-1-git-send-email-konrad.wilk@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 21.11.14 at 23:17, <konrad.wilk@oracle.com> wrote:
> Konrad Rzeszutek Wilk (7):
>       xen/pciback: Don't deadlock when unbinding.
>       driver core: Provide an wrapper around the mutex to do lockdep warnings
>       xen/pciback: Include the domain id if removing the device whilst still in use
>       xen/pciback: Print out the domain owning the device.
>       xen/pciback: Remove tons of dereferences
>       PCI: Expose pci_load_saved_state for public consumption.
>       xen/pciback: Restore configuration space when detaching from a guest.

So my "xen-pciback: drop SR-IOV VFs when PF driver unloads" isn't
among them, nor is there any alternative. What's the status of that
patch (or the problem that prompted its creation)?

Jan

