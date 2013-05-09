Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871Ab3EIAnG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 20:43:06 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45952 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab3EIAnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 20:43:05 -0400
Date: Thu, 9 May 2013 08:42:51 +0800
From: Wang YanQing <udknight@gmail.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, jslaby@suse.cz,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH]TTY: Fix tty can't be restarted by TCXONC ioctl request
Message-ID: <20130509004251.GA2042@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	Peter Hurley <peter@hurleysoftware.com>,
	Greg KH <gregkh@linuxfoundation.org>, jslaby@suse.cz,
	linux-kernel@vger.kernel.org
References: <20130507184734.GA2459@udknight>
 <20130507185800.GA10713@kroah.com>
 <20130508015545.GA1937@udknight>
 <20130508020200.GA15695@kroah.com>
 <20130508131624.GA1938@udknight>
 <518A6CAF.9020301@hurleysoftware.com>
 <20130508171247.GA6925@udknight>
 <518A9A37.9000405@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <518A9A37.9000405@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 02:32:23PM -0400, Peter Hurley wrote:
> Perhaps you misunderstood. The snippet above does indeed restart
> a tty which has been stopped via STOP_CHAR(tty) and the termios
> IXON flag cleared.

Thanks Peter, I get your meaning, and I think your suggestion
is right, not only because your reason, but also I find
this patch change the user interface behavior silently,
it will cause data lost or others' undesired behavior if
TCXONC restart tty but another side is not ready, it is bad.

I will send the V2.

Thanks.
