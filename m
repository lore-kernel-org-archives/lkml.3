Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbaIALUF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:20:05 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:33660 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258AbaIALUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:20:03 -0400
X-Greylist: delayed 649 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Sep 2014 07:20:03 EDT
Message-ID: <1409569752.24385.12.camel@linux-fkkt.site>
Subject: Re: [3.16.1 REGRESSION]: Simtec Entropy Key (cdc-acm) broken in 3.16
From: Oliver Neukum <oliver@neukum.org>
To: Nix <nix@esperi.org.uk>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 01 Sep 2014 13:09:12 +0200
In-Reply-To: <878um4tg09.fsf@spindle.srvr.nix>
References: <878um4tg09.fsf@spindle.srvr.nix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I'll do a bisection of the cdc-acm changes since 3.15 tomorrow night and
> see if I can find the commit at fault.

Thank you for the report. Please let me know the results of your
bisection.

	Regards
		Oliver



