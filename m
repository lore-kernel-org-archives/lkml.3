Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758899Ab3BLXJH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 18:09:07 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:59081 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757205Ab3BLXJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 18:09:05 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [char-misc-next 01/12 v3] mei: Rename mei_device to mei_host
Date: Tue, 12 Feb 2013 23:09:00 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-5-generic; KDE/4.3.2; x86_64; ; )
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "Winkler, Tomas" <tomas.winkler@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1360694222-27632-1-git-send-email-sameo@linux.intel.com> <20130212212935.GJ20996@sortiz-mobl> <20130212213823.GA20745@kroah.com>
In-Reply-To: <20130212213823.GA20745@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302122309.01176.arnd@arndb.de>
X-Provags-ID: V02:K0:a2Bgm06O2VjeaU3TNkfLysqXUc5YYbf56uRrXYx9S+d
 1MuRBmhNLZRg3qyAVgT+GyZ5u2xiyLp4KLApP+s/2EXMd7KqVO
 21IXyQQiTJeBmSukNcy/gODYlJxUWauu95Jk7qMZogwku0ObzU
 +r/M7fh1HAWz5lQ1h3J8PQtTKnCxwUrZoHulmoUKbktya/6oPT
 VYaZNNKeQULccyBwfV3IeTBlO5rDKESIx7EjSF/jQCn+5Un6a9
 wgfX5z4KVyI/L2rwOHumReXZsts4+J7Us7y6T0PWRu2+3bFT9c
 KdWLbJZkw32opm/K5rq4nwmZdfHXtqgijNl4CcTT68kZqwU3tQ
 lRBbehq11r4xocikWNWI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 February 2013, gregkh@linuxfoundation.org wrote:
> > 
> > > Please let's find something that makes both hw and Linux happy
> > I still believe it makes sense to use mei_device for what we add to the MEI
> > bus. I'd be fine with mei_bus_device as well, but that would somehow look
> > a bit awkward. Greg, Arnd, any preference ?
> 
> "mei_device" works the best for me.  Tomas, what you think of as a "MEI
> Device" really is a "MEI Controller", it bridges the difference between
> the PCI bus and your new MEI bus, so you will need to start thinking of
> these things a bit differently now that you have created your own little
> virtual bus.

Yes, I agree. mei_bus_device would also work as the name for the controller,
but not for the devices attached to it IMO.

	Arnd
