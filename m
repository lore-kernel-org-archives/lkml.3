Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbaFNRuN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 13:50:13 -0400
Received: from fallback3.mail.ox.ac.uk ([163.1.2.167]:51472 "EHLO
	fallback3.mail.ox.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758AbaFNRuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 13:50:12 -0400
X-Greylist: delayed 1572 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Jun 2014 13:50:12 EDT
From: Beojan Stanislaus <beojan.stanislaus@queens.ox.ac.uk>
To: linux-kernel@vger.kernel.org
Subject: intel_rapl does not support CPU family 6 model 60
Date: Sat, 14 Jun 2014 18:23:56 +0100
Message-ID: <11698571.F7xSk19hqq@quee2769-2>
User-Agent: KMail/4.13.1 (Linux/3.15.0; KDE/4.13.1; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="iso-8859-1"
X-Oxford-Username: quee2769
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The intel_rapl driver gives the message 

	intel_rapl: does not support CPU family 6 model 60

on an Intel 4700MQ processor, with the 3.15.0 kernel. A message about this 
appears to have been posted in April, but there was no response since a 
message from Jacob Pan that it should be supported, but hadn't been tested, on 
April 26, 2014.

Sincerely,

Beojan Stanislaus
