Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab3LCWRN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 17:17:13 -0500
Received: from toccata.ens-lyon.fr ([140.77.166.68]:50884 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851Ab3LCWRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 17:17:10 -0500
Date: Wed, 4 Dec 2013 07:17:03 +0900
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Aldo Iljazi <mail@aldo.io>
Cc: w.d.hubbs@gmail.com, chris@the-brannons.com, kirk@reisers.ca,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: speakup: synth.c: removed a space
Message-ID: <20131203221703.GE8138@type>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Aldo Iljazi <mail@aldo.io>, w.d.hubbs@gmail.com,
	chris@the-brannons.com, kirk@reisers.ca, gregkh@linuxfoundation.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1386101283-14650-1-git-send-email-mail@aldo.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1386101283-14650-1-git-send-email-mail@aldo.io>
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aldo Iljazi, le Tue 03 Dec 2013 22:08:03 +0200, a écrit :
> Line 468: Removed a space before a semicolon.

Err, I'd rather make it really visible that the for loop doesn't have
its first statement?

Samuel
