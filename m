Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab3DMCBm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 22:01:42 -0400
Received: from mail.digidescorp.com ([50.73.98.161]:4931 "EHLO
	mail.digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab3DMCBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 22:01:41 -0400
X-Greylist: delayed 441 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Apr 2013 22:01:41 EDT
DomainKey-Signature: a=rsa-sha1; s=MDaemon; d=digidescorp.com;
	c=simple; q=dns; h=message-id:from;
	b=bqO22c0QX+kPwBLixV69BqUerrdoS7PmiVfXxGjpXl4FKZ2Pp320MTAsQ4QG
	nHL4H+xtK8gxZ2YqG0eV22EKjm/AP3gr8ZkCb+Bx6I6VrETBgXfOgrghd
	5sVgtJzB5pkhI4Nj/K3H93V1IGqDAQJm/FpsbMRyrXnsjoLqNJlS5s=;
X-Spam-Processed: mail.digidescorp.com, Fri, 12 Apr 2013 20:54:09 -0500
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: steve@digidescorp.com
X-MDRemoteIP: 99.135.161.176
X-Return-Path: prvs=1815aa1649=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
Message-ID: <1365818043.1691.23.camel@iscandar.digidescorp.com>
Subject: Re: [PATCH] mmc: debugfs: Add debugfs ability to read CID and CSD
From: "Steven J. Magnani" <steve@digidescorp.com>
To: Johan Rudholm <jrudholm@gmail.com>
Cc: Steve Magnani <smagnani@iscandar.digidescorp.com>,
        Chris Ball <cjb@laptop.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Date: Fri, 12 Apr 2013 20:54:03 -0500
In-Reply-To: <CA+20K0DFA9r+fLhhbFnzx+t2wQ6+UH3DAWhoiF2W1g=ok8hyBQ@mail.gmail.com>
References: <1365796013-11399-1-git-send-email-smagnani@iscandar.digidescorp.com>
	 <CA+20K0DFA9r+fLhhbFnzx+t2wQ6+UH3DAWhoiF2W1g=ok8hyBQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2013-04-13 at 01:06 +0200, Johan Rudholm wrote: 
> I believe these registers are already available as sysfs nodes? I
> don't have access to the proper hardware right now, but I'm pretty
> sure you'll find something if you do for instance "find /sys -name
> csd".

Ahh. Thanks for the tip; I hadn't thought to look there since I found
the ext_csd under debugfs.
------------------------------------------------------------------------
Steven J. Magnani               "I claim this network for MARS!
www.digidescorp.com              Earthling, return my space modulator!"

#include <standard.disclaimer> 


