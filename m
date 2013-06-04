Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813Ab3FDVDr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 17:03:47 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:56553 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab3FDVDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 17:03:44 -0400
X-Greylist: delayed 1257 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Jun 2013 17:03:44 EDT
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuxqAOxQrlFV5qjOPGdsb2JhbABagwmDAyOFALcuBAF6FwMBAQEBODWCJAEFOhwjEAgkJQ8FJQoaiCS9dhaNcYEdB4J6YQOXPoYujGuBOTo
X-IronPort-AV: E=Sophos;i="4.87,802,1363129200"; 
   d="scan'208";a="563905416"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Tue, 4 Jun 2013 22:48:01 +0200
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dave Airlie <airlied@redhat.com>, nouveau@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: [REGRESSION] nouveau: Resume hung after protecting against client
 races (MBA3,1)
Message-ID: <20130604204801.GA1168@polaris.bitmath.org>
References: <1341469873-1582-1-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341469873-1582-1-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

The new mutexes in nvc0/nv50 (fadb17190/b509656) break resume on my
MBA3,1. A dead-lock somewhere, perhaps? Reverting fixes the problem.

Thanks,
Henrik
