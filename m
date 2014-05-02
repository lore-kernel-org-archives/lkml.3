Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbaEBLpv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 07:45:51 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:39328 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbaEBLpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 07:45:50 -0400
MIME-Version: 1.0
Date: Fri, 2 May 2014 17:15:49 +0530
Message-ID: <CAPUj1OMJ8cE1cNTe8CjgBP2GTCXzi__Yg0+OoomME6=TShgqJg@mail.gmail.com>
Subject: Linux Interrupt Context maps to ARM CPSR.mode = IRQ
From: Mj Embd <mj.embd@gmail.com>
To: kernelnewbies <kernelnewbies@kernelnewbies.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

As per a lot of linux documentation some components work in process
context and some work in interrupt context.

If we try to map these contexts to ARM processor modes then is it
safely to assume that
Process Context : CPSR.mode = SVC
Interrupt Context : CPSR.mode = IRQ

If not how to define interrupt context properly. Confusing at times.

-- 
-mj
