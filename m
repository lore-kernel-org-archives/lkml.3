Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbaENJXy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 05:23:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46752 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753656AbaENJXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 05:23:51 -0400
Date: Wed, 14 May 2014 11:23:47 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Mike Waychison <mikew@google.com>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Purpose of dmi-sysfs kernel module
Message-ID: <20140514112347.3f630565@endymion.delvare>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike, Bjorn,

Sorry for joining the party a little late but I am just discovering the
dmi-sysfs kernel module. I have to admit that I am very curious about
why it was needed. What does it let you achieve that you couldn't
already do with dmidecode [1]?

I read on LWM [2] that you were mostly interested in type 15 records,
to gain access to the System Event Log information. Well, "dmidecode -t
15" does exactly that. It may be a bit late now but if anything is
missing from dmidecode, I would rather add it there than implement a
separate solution.

[1] http://www.nongnu.org/dmidecode/
[2] http://lwn.net/Articles/429427/

Thanks,
-- 
Jean Delvare
SUSE L3 Support
