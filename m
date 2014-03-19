Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964911AbaCSMZD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 08:25:03 -0400
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:2877 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932721AbaCSMZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 08:25:00 -0400
X-Greylist: delayed 1119 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Mar 2014 08:24:59 EDT
Message-ID: <1395230578.12633.21.camel@thorin>
Subject: Re: [PATCH] Coccicheck: Remove memcpy to struct assignment test
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: Julia.Lawall@lip6.fr, Gilles.Muller@lip6.fr, nicolas.palix@imag.fr,
        mmarek@suse.cz, linux-kernel@vger.kernel.org, cocci@systeme.lip6.fr,
        gregkh@linuxfoundation.org, bernat.ada@gmail.com,
        elezegarcia@gmail.com, kernel-janitors@vger.kernel.org
Date: Wed, 19 Mar 2014 13:02:58 +0100
In-Reply-To: <1395177092-3023-1-git-send-email-peter.senna@gmail.com>
References: <1395177092-3023-1-git-send-email-peter.senna@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-DCC-wuwien-Metrics: esgaroth.petrovitsch.priv.at 1290; Body=11 Fuz1=11
	Fuz2=11
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	*  0.1 AWL AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Die, 2014-03-18 at 22:11 +0100, Peter Senna Tschudin wrote:
> The Coccinelle script scripts/coccinelle/misc/memcpy-assign.cocci look
> for opportunities to replace a call to memcpy by a struct assignment.
> This patch removes memcpy-assign.cocci as it is not clear that this
> convention has an impact on the generated code.

Using struct assignment keeps the type check and is just for this reason
always preferable over memcpy().

Kind regards,
	Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at

