Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445AbaLWSPY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 13:15:24 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:60697 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaLWSPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 13:15:23 -0500
MIME-Version: 1.0
Date: Tue, 23 Dec 2014 23:45:22 +0530
Message-ID: <CAGnW=BbmpJqvbuznhxXsfZYz0wWMOQ851f+E3hWrAawOSZWtpQ@mail.gmail.com>
Subject: nand ecc
From: punnaiah choudary kalluri <kalluripunnaiahchoudary@gmail.com>
To: Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Cc: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Punnaiah Choudary <kpc528@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

  I have the following confusions regarding the nand ecc algorithms:
Haming and BCH

Request your help to clarify the below concerns.

Hamming  Mode:
   What will happen if the data has more than two bit errors for codeword?
   Will the nand_correct_data() function returns uncorrectable ecc error ?

BCH mode:
 Assume that the BCH block can correct upto 24bit errors. what will
happen if the data
has more than 24 bit errors?
Will the nand_bch_correct_data() function returns uncorrectable ecc error?


Regards,
Punnaiah
