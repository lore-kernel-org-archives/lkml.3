Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932350AbaHFTcY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 15:32:24 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:56851 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757044AbaHFTcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 15:32:22 -0400
Date: Wed, 6 Aug 2014 21:32:11 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Nick Krause <xerofoify@gmail.com>
Cc: "Koehrer Mathias (ETAS/ESW5)" <mathias.koehrer@etas.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] Fix e1000e with Intel 82572EI that has no hardware
 timestamp support
Message-ID: <20140806193211.GC6611@netboy>
References: <bbcbf584e3624059bf7a0d2186fec6b4@FE-MBX1012.de.bosch.com>
 <20140806191744.GB6611@netboy>
 <CAPDOMVjYkfM49E9DM0=SDDRncLQbXxR8NQE9SrsW++YycMGU5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDOMVjYkfM49E9DM0=SDDRncLQbXxR8NQE9SrsW++YycMGU5w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 03:20:43PM -0400, Nick Krause wrote:
> My question was as follows after reading the thread here is this patch
> good or do I need to edit it
> some more based on the thread and only putting part of the if
> statement in an unlikely statement.

Huh? Are you Mathias Koehrer?

I was only complaining about the formatting of the change log 
comment. As far as the code goes, please see Alexander Duyck's
emails.

Thanks,
Richard
