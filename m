Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867Ab3LDEf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 23:35:26 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:37094 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489Ab3LDEfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 23:35:25 -0500
X-Originating-IP: 176.58.169.25
Date: Wed, 4 Dec 2013 06:35:15 +0200
From: Aldo Iljazi <mail@aldo.io>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>, w.d.hubbs@gmail.com,
        chris@the-brannons.com, kirk@reisers.ca, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: speakup: synth.c: removed a space
Message-ID: <20131204043515.GB6909@linux>
References: <1386101283-14650-1-git-send-email-mail@aldo.io>
 <20131203221703.GE8138@type>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131203221703.GE8138@type>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Samuel Thibault wrote:

> Err, I'd rather make it really visible that the for loop doesn't have
> its first statement?

Wouldn't it be better if you add a comment there? So it would follow the
coding style?
-- 
Aldo Iljazi
