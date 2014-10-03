Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbaJCMX1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 08:23:27 -0400
Received: from resqmta-po-04v.sys.comcast.net ([96.114.154.163]:49827 "EHLO
	resqmta-po-04v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752006AbaJCMXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 08:23:24 -0400
Date: Fri, 3 Oct 2014 07:23:21 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Paul Bolle <pebolle@tiscali.nl>
cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: Why do we still have 32 bit counters? Interrupt counters overflow
 within 50 days
In-Reply-To: <1412338512.19413.85.camel@x220>
Message-ID: <alpine.DEB.2.11.1410030722390.9084@gentwo.org>
References: <alpine.DEB.2.11.1410030435260.8324@gentwo.org> <alpine.DEB.2.11.1410031231420.4383@nanos> <alpine.DEB.2.11.1410030653040.8496@gentwo.org> <1412338512.19413.85.camel@x220>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Oct 2014, Paul Bolle wrote:

> dc -e "1 k 2 32 ^ 1000 / 86400 / p"
> 49.7
>
> (That was the number I remembered from stories about a ancient Windows
> lockup.)

Well yes, I used bc which discards the remainder on integer divides

