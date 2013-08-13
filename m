Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936Ab3HMSWb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 14:22:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39176 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691Ab3HMSW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 14:22:29 -0400
Date: Tue, 13 Aug 2013 11:22:28 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        =?iso-8859-1?Q?Beno=EEt?= Coussno <b-cousson@ti.com>,
        Paul Walmsley <paul@pwsan.com>, Sourav Poddar <sourav.poddar@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, Felipe Balbi <balbi@ti.com>,
        Koen Kooi <koen@circuitco.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: Platform device tester - Allow removal
Message-ID: <20130813182228.GF7740@kroah.com>
References: <1376386470-27328-1-git-send-email-panto@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376386470-27328-1-git-send-email-panto@antoniou-consulting.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 12:34:30PM +0300, Pantelis Antoniou wrote:
> +/*
> + * pdevtest.c
> + *
> + * Tester of platform device's operation.
> + *
> + * Copyright (C) 2013, Pantelis Antoniou <panto@antoniou-consulting.com>
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */

Minor legal nit, for the future, you don't actually say what the license
is for this file.  You imply it by using the GPL paragraphs about
warranties, and the totally-useless office address information (do you
really want to track the office movements of the FSF for the next 40
years?), but it's not specified.

In the future, you can drop these two paragraphs, and just add a
sentance about the file being released under the GPLv2 instead.

thanks,

greg k-h
