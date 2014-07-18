Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946068AbaGRVDi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 17:03:38 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47253 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932406AbaGRVDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 17:03:37 -0400
Message-ID: <1405717414.30262.12.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH] parisc: Remove FIXME comment
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: deller@gmx.de, tiwai@suse.de, jkosina@suse.cz, joe@perches.com,
        dave.anglin@bell.net, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 18 Jul 2014 14:03:34 -0700
In-Reply-To: <1405715823-17492-1-git-send-email-xerofoify@gmail.com>
References: <1405715823-17492-1-git-send-email-xerofoify@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.12.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-18 at 16:37 -0400, Nicholas Krause wrote:
> The comment for size of frame not being needed is incorrect , the
> function called needs this parameter.

Actually, that's not correct.  The point of the FIXME is that fram_size
is only used in a debug print and could be eliminated since the
internals of the function excluding the debugging statements don't use
it.

James


