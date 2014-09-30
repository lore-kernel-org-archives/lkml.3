Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467AbaI3XSQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 19:18:16 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:41062 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750780AbaI3XSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 19:18:14 -0400
X-Sasl-enc: BuqWnyY5FrKA3MW+J5sbXLO7mDBNYkij8UJMK+ON/3kC 1412119093
Date: Tue, 30 Sep 2014 20:18:01 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        kernel list <linux-kernel@vger.kernel.org>, jack@suse.cz,
        linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca,
        Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: ext4: 3.17? problems
Message-ID: <20140930231801.GB729@khazad-dum.debian.net>
References: <20140929114408.GC2738@quack.suse.cz>
 <87iok6ojis.fsf@openvz.org>
 <20140928124658.GB6694@thunk.org>
 <20140930210108.GB14283@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140930210108.GB14283@amd>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2014, Pavel Machek wrote:
> > > So I had to hard power-down the machine. That should be perfectly
> > > safe, as ext4 has a journal, and this is plain SATA disk, right?
> >   Yes, it should be safe.
> 
> Good.

...

> Is there some phase during shutdown where journalling no longer
> protects fs integrity?

Hmm... what kind of backing device?  Because I have Crucial/Micron M500 SSDs
here that _always_ complain (in a SMART counter/attribute) that they have
been subject to a sudden poweroff *when subject to a normal system
shutdown*.

This is scaring me a great deal.  Are we doing something different for SSDs
in the scsi-sd or libata shutdown paths?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
