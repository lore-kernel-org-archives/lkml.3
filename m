Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273AbaJ0Pab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 11:30:31 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:58845 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbaJ0Pa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 11:30:28 -0400
Message-ID: <1414423841.20978.1.camel@mm-sol.com>
Subject: Re: [PATCH 2/4] Input: pmic8xxx-keypad - use regmap_field for
 register access
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mark Brown <broonie@kernel.org>, Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Date: Mon, 27 Oct 2014 17:30:41 +0200
In-Reply-To: <20141013140218.GG27755@sirena.org.uk>
References: <1412675448-11990-1-git-send-email-iivanov@mm-sol.com>
	 <1412675448-11990-3-git-send-email-iivanov@mm-sol.com>
	 <20141007172606.GG16469@dtor-ws> <1412759584.13569.0.camel@iivanov-dev>
	 <1412760633.13569.4.camel@iivanov-dev> <54357BA7.3010609@codeaurora.org>
	 <20141008181314.GC14423@dtor-ws> <5435808A.7070203@codeaurora.org>
	 <20141008200426.GJ4609@sirena.org.uk> <20141008203233.GA15198@dtor-ws>
	 <20141013140218.GG27755@sirena.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.13.6-fta3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Dmitry, 

On Mon, 2014-10-13 at 16:02 +0200, Mark Brown wrote:
> On Wed, Oct 08, 2014 at 01:32:33PM -0700, Dmitry Torokhov wrote:
> > On Wed, Oct 08, 2014 at 09:04:26PM +0100, Mark Brown wrote:
> > > On Wed, Oct 08, 2014 at 11:20:58AM -0700, Stephen Boyd wrote:
> 
> > > > Srini/Mark, any reason why the regmap_field structure is opaque?
> 
> > > So you can't peer into it and rely on the contents.  I can see it being
> > > useful to add a bulk allocator.
> 
> > And then one have to define offsets in an array and use awkward syntax
> > to access individual fields. Can we just reply on reviews/documentation
> > for users to not do wrong thing?
> 
> I have very little confidence in users not doing awful things to be
> honest, this is the sort of API where the users are just random things
> all over the kernel so this sort of thing tends to be found after the
> fact.  I get a lot of these in drivers that just got thrown over the
> wall so nobody really knows what things are doing when you do find them.
> 
> If the standard allocators aren't doing a good job (I've not checked)
> I'd much rather handle this inside the API if we can.
> 

Is there something that I can help here or patches are good as they are? :-)

Regards,
Ivan
