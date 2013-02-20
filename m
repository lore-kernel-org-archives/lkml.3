Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935223Ab3BTUaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 15:30:20 -0500
Received: from smtprelay-b31.telenor.se ([213.150.131.20]:33173 "EHLO
	smtprelay-b31.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934793Ab3BTUaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 15:30:17 -0500
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtNHAPcxJVFV5qjOOWdsb2JhbABFhWAjhH21X4EBFwMBAQEBIRc0gh8BAQQBOhwjBQsIAyElDwUlChqIHwrAZBWOeQeCX2EDliuGAo1i
X-IronPort-AV: E=Sophos;i="4.84,704,1355094000"; 
   d="scan'208";a="279976158"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 20 Feb 2013 21:31:40 +0100
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] hid driver transport cleanup
Message-ID: <20130220203140.GA1425@polaris.bitmath.org>
References: <1360334256-22127-1-git-send-email-benjamin.tissoires@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360334256-22127-1-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> so, here is the hid drivers cleanup. The aim is to remove as much as possible
> direct calls to usbhid for hid drivers. Thus, other transport layers can use
> the existing hid drivers (like I2C or uhid).
> 
> Henrik, patches 1 to 5 are yours. I just rebased and double-checked them. Please
> add you Signed-off-by if you are happy with the rebase.

I wanted to Ack 4-6 as well, but I think they warrant a bit more
elaborate commit messages. Other than that, it looks all good to me.

Cheers,
Henrik
