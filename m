Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255AbaEGKAM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 06:00:12 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:54875 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754598AbaEGKAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 06:00:09 -0400
Message-ID: <1399456806.6659.20.camel@x220>
Subject: Re: [PATCH] libata-sff: remove dead code
From: Paul Bolle <pebolle@tiscali.nl>
To: Alan Cox <alan@linux.intel.com>
Cc: David Howells <dhowells@redhat.com>, Tejun Heo <tj@kernel.org>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 07 May 2014 12:00:06 +0200
In-Reply-To: <1399456196.2458.53.camel@acox1-desk.ger.corp.intel.com>
References: <1399204229.8729.15.camel@x220>
	 <1399411616.2458.45.camel@acox1-desk.ger.corp.intel.com>
	 <1399454604.6659.13.camel@x220>
	 <1399456196.2458.53.camel@acox1-desk.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 May 2014 10:00:07.0412 (UTC) FILETIME=[20164B40:01CF69DB]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-07 at 10:49 +0100, Alan Cox wrote:
> Unless you are editing the config with out of tree changes. Which is
> possible which is why I said ask Dave. It's probably fine but best to be
> safe.

If you mean adding a "config NO_ATA_LEGACY" entry to some Kconfig file,
and setting that symbol during "make *config", that will obviously work.

But if you mean (hand) editing the .config, that wouldn't work, as the
line for CONFIG_NO_ATA_LEGACY would be dropped during "make *config",
wouldn't it?


Paul Bolle

