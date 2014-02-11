Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400AbaBKISh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 03:18:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36833 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbaBKISf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 03:18:35 -0500
Message-ID: <1392104633.6668.14.camel@linux-fkkt.site>
Subject: Re: [PATCH 1/2 v2] usbnet: fix bad header length bug
From: Oliver Neukum <oneukum@suse.de>
To: Emil Goode <emilgoode@gmail.com>
Cc: =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Ming Lei <ming.lei@canonical.com>, Mark Brown <broonie@linaro.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Glen Turner <gdt@gdt.id.au>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20140210155436.GA4258@lianli>
References: <1391987174-21828-1-git-send-email-emilgoode@gmail.com>
	 <1392014458.21271.6.camel@linux-fkkt.site> <20140210115812.GA4278@lianli>
	 <1392034947.2082.30.camel@linux-fkkt.site> <87iosn86en.fsf@nemi.mork.no>
	 <20140210155436.GA4258@lianli>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Feb 2014 08:43:53 +0100
Mime-Version: 1.0
X-Mailer: Evolution 3.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-10 at 16:54 +0100, Emil Goode wrote:

> Since the checks that need to be added in various places are all in
> the same subsystem I think it could be done in as little as one patch?

Yes, please definitely. Best for bisectability.

> If nobody have any objections I will try removing the generic check and
> introduce checks where nessecary.

Thank you

	Regards
		Oliver


