Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751073Ab3HSPWt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 11:22:49 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60703 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750740Ab3HSPWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 11:22:48 -0400
Message-ID: <1376925765.2069.24.camel@dabdike.int.hansenpartnership.com>
Subject: Re: UEFI Plugfest 2013 -- New Orleans
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Date: Mon, 19 Aug 2013 08:22:45 -0700
In-Reply-To: <20130819125507.GA19093@srcf.ucam.org>
References: <20130816152030.GL2133@tuxdriver.com>
	 <1376900735.2322.26.camel@shinybook.infradead.org>
	 <20130819125507.GA19093@srcf.ucam.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-08-19 at 13:55 +0100, Matthew Garrett wrote:
> On Mon, Aug 19, 2013 at 09:25:35AM +0100, David Woodhouse wrote:
> 
> > Every deviation from the spec (or common sense), however minor, should
> > show up as a clear failure. Even the ones we *have* been able to work
> > around, because we still want them *fixed*.
> 
> Why? It's not like we can ever stop carrying that code.

The reason for doing it is that we have a buildable reference
implementation that's fully spec compliant we can then make the basis of
a test suite for UEFI.

I am worried about it from another angle, though: history has shown
we're not very good at maintaining configurations which we don't really
use ... since every distro will turn this off (or the workarounds on),
it's going to be a bit of work for someone to make sure it still
functions.

James


