Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751248AbaEQToW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 15:44:22 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:52294 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbaEQToU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 15:44:20 -0400
X-Google-Original-From: Parag Warudkar <parag@gmail.com>
Date: Sat, 17 May 2014 15:43:51 -0400 (EDT)
From: Parag Warudkar <parag.lkml@gmail.com>
X-X-Sender: parag@parag-Z230
To: mathias.nyman@intel.com
cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: xhci dmesg flood on short packet
Message-ID: <alpine.DEB.2.10.1405171530140.17496@parag-Z230>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I see a continuous flood of below messages on plugging in/using my USB 
token. (The comp code wasn't in the original message - I added it.) From 
what I can tell the device continues to work as expected.

Should the warning be disabled for COMP_SHORT_TX like it is for COMP_STOP 
and COMP_STOP_INVAL?

Parag

[104692.771649] xhci_hcd 0000:00:14.0: WARN Event TRB comp code 13 for 
slot 2 ep 10 with no TDs queued?
[104692.777279] xhci_hcd 0000:00:14.0: WARN Event TRB comp code 13 for 
slot 2 ep 10 with no TDs queued?
[104692.793894] xhci_hcd 0000:00:14.0: WARN Event TRB comp code 13 for 
slot 2 ep 10 with no TDs queued?
[104692.813033] xhci_hcd 0000:00:14.0: WARN Event TRB comp code 13 for 
slot 2 ep 10 with no TDs queued?
[104692.823476] xhci_hcd 0000:00:14.0: WARN Event TRB comp code 13 for 
slot 2 ep 10 with no TDs queued?
