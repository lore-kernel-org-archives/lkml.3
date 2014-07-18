Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965996AbaGRRTF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 13:19:05 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:42688 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894AbaGRRTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 13:19:03 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1407181042300.979-100000@iolanthe.rowland.org>
References: <CAPDOMVhu1Pd8qGcPBRJ0HUAb+S2x3hqcTBXfy1-XG_4aW1otXw@mail.gmail.com>
	<Pine.LNX.4.44L0.1407181042300.979-100000@iolanthe.rowland.org>
Date: Fri, 18 Jul 2014 13:19:01 -0400
Message-ID: <CAPDOMVhzpoC2UBnmowzG7yX7kES2NJDGyS9_iXhVaQ=bnXs91g@mail.gmail.com>
Subject: Re: hcd.c Fix me statements
From: Nick Krause <xerofoify@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <gregkh@linuxfoundation.org>, mail@beyermatthias.de,
        hdegoede@redhat.com, sarah.a.sharp@linux.intel.com,
        dan.j.williams@intel.com, valentine.barshak@cogentembedded.com,
        Ming Lei <ming.lei@canonical.com>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 10:45 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Fri, 18 Jul 2014, Nick Krause wrote:
>
>> I am assuming this is a stupid question but since I am new I will ask it anyway.
>> Can the  usb_bus  structure be Null? If can I will send it a patch removing the
>> fix mes on  lines 854 and 878 of hcd.c .
>
> Line numbers in a source file usually aren't very useful.  They're
> different in every version of the kernel.  Instead just mention which
> functions you're talking about.  It looks like
> authorized_default_show() and authorized_default_store().
>
> Yes, it's true that usb_bus (which is a pointer, not a structure) can
> never be NULL.
>
> Alan Stern
>

If that is the case I will send a patch, removing the lines as it
seems we don't need to check for NULL then based
on your information.
Cheers Nick
