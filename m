Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426Ab3I0SFX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 14:05:23 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41514 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753374Ab3I0SFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 14:05:20 -0400
X-Sasl-enc: fC6qRiXozxRRYyf31zYMSp+HVeYfmtNcwQaUpXWKsda6 1380305119
Date: Fri, 27 Sep 2013 15:05:16 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Yves-Alexis Perez <corsac@debian.org>
Cc: Aaron Lu <aaron.lu@intel.com>, linux-acpi@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Daniel Vetter <daniel@ffwll.ch>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Lee Chun-Yi <joeyli.kernel@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Ben Jencks <ben@bjencks.net>, Steven Newbury <steve@snewbury.org.uk>,
        James Hogan <james@albanarts.com>, Kamal Mostafa <kamal@canonical.com>,
        Joerg Platte <jplatte@naasa.net>, Kalle Valo <kvalo@adurom.com>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        =?iso-8859-1?Q?J=F6rg?= Otte <jrg.otte@gmail.com>,
        Mike Galbraith <bitbucket@online.de>
Subject: Re: [PATCH v3 4/4] thinkpad-acpi: fix handle locate for video and
 query of _BCL
Message-ID: <20130927180516.GC4140@khazad-dum.debian.net>
References: <1380016052-15315-1-git-send-email-aaron.lu@intel.com>
 <1380016052-15315-5-git-send-email-aaron.lu@intel.com>
 <20130927152035.GB4140@khazad-dum.debian.net>
 <1380295986.16310.19.camel@scapa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380295986.16310.19.camel@scapa>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Sep 2013, Yves-Alexis Perez wrote:
> On ven., 2013-09-27 at 12:20 -0300, Henrique de Moraes Holschuh wrote:
> > Some testing on a *60 (T60,X60...) would also be best, I cannot test
> > this on
> > my T43.
> > 
> > Anyway, the code itself looks fine, so:
> 
> I can test on T61, would that help?

I think so.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
