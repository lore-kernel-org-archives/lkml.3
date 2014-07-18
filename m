Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbaGREwZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 00:52:25 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:54531 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbaGREwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 00:52:24 -0400
MIME-Version: 1.0
Date: Fri, 18 Jul 2014 00:52:23 -0400
Message-ID: <CAPDOMVhu1Pd8qGcPBRJ0HUAb+S2x3hqcTBXfy1-XG_4aW1otXw@mail.gmail.com>
Subject: hcd.c Fix me statements
From: Nick Krause <xerofoify@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: stern@rowland.harvard.edu, mail@beyermatthias.de, hdegoede@redhat.com,
        sarah.a.sharp@linux.intel.com, dan.j.williams@intel.com,
        valentine.barshak@cogentembedded.com, ming.lei@canonical.com,
        michael.opdenacker@free-electrons.com, linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am assuming this is a stupid question but since I am new I will ask it anyway.
Can the  usb_bus  structure be Null? If can I will send it a patch removing the
fix mes on  lines 854 and 878 of hcd.c .
Cheers Nick
