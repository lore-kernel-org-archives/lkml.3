Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933729AbaJUWMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 18:12:48 -0400
Received: from matrix.voodoobox.net ([75.127.97.206]:49331 "EHLO voodoobox.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932998AbaJUWMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 18:12:47 -0400
X-Greylist: delayed 2617 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Oct 2014 18:12:47 EDT
Message-ID: <1413926943.8038.0.camel@dillow0.mtv.corp.google.com>
Subject: Re: [PATCH] net: typhoon: Remove redundant casts
From: David Dillow <dave@thedillows.org>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 21 Oct 2014 14:29:03 -0700
In-Reply-To: <1413903103-3047-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1413903103-3047-1-git-send-email-linux@rasmusvillemoes.dk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-21 at 16:51 +0200, Rasmus Villemoes wrote:
> Both image_data and typhoon_fw->data are const u8*, so the cast to u8*
> is unnecessary and confusing.
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>

Acked-by: David Dillow <dave@thedillows.org>

