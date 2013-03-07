Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab3CGKda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 05:33:30 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:41029 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755527Ab3CGKd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 05:33:27 -0500
MIME-Version: 1.0
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Thu, 7 Mar 2013 11:32:47 +0100
Message-ID: <CAPybu_3LfWLYLSn52dgFDuBTASLvQ0_XWsywH=Avpma+4s921g@mail.gmail.com>
Subject: HOWTO Undo/Revert of_platform_populate?
To: LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I have an FPGA attached to the pci bus. The FPGA has an internal bus
with multiple cores that are already supported in the kernel.

I have made a driver that populates those cores using a user provided
device tree. I use the function of_platform_populate for that.

All this is working fine, but now I need a method to undo what
of_platform_populate does when the fpga is reprogrammed.

I haven't found any function that does this in the api.

Before implementing my own I would like to know if am I missing something?


Thanks!

-- 
Ricardo Ribalda
