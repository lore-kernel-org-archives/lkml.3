Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240AbaLBPKF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 10:10:05 -0500
Received: from mail.emea.novell.com ([130.57.118.101]:56036 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbaLBPKD convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Tue, 2 Dec 2014 10:10:03 -0500
Message-Id: <547DD64602000078000C2DC0@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Tue, 02 Dec 2014 15:09:58 +0000
From: "Jan Beulich" <jbeulich@suse.com>
To: <konrad.wilk@oracle.com>
Cc: <linux@eikelenboom.it>, <bhelgaas@google.com>,
        <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH v4] Fixes for PCI backend for 3.19
References: <1416608271-18931-1-git-send-email-konrad.wilk@oracle.com>
 <547D9E13020000780004C0B3@mail.emea.novell.com>
 <20141202150514.GC27869@laptop.dumpdata.com>
In-Reply-To: <20141202150514.GC27869@laptop.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> 12/02/14 4:05 PM >>>
>On Tue, Dec 02, 2014 at 10:10:11AM +0000, Jan Beulich wrote:
>> >>> On 21.11.14 at 23:17, <konrad.wilk@oracle.com> wrote:
>> > Konrad Rzeszutek Wilk (7):
>> >       xen/pciback: Don't deadlock when unbinding.
>> >       driver core: Provide an wrapper around the mutex to do lockdep warnings
>> >       xen/pciback: Include the domain id if removing the device whilst still in use
>> >       xen/pciback: Print out the domain owning the device.
>> >       xen/pciback: Remove tons of dereferences
>> >       PCI: Expose pci_load_saved_state for public consumption.
>> >       xen/pciback: Restore configuration space when detaching from a guest.
>> 
>> So my "xen-pciback: drop SR-IOV VFs when PF driver unloads" isn't
>> among them, nor is there any alternative. What's the status of that
>> patch (or the problem that prompted its creation)?
>
>Oh, I've it in my queue. Um, here is what I did to it - I hadn't
>yet tested it - hence the reason it is not on that list.

Yeah, if you like it better that way, it looks okay to me now.

Jan

