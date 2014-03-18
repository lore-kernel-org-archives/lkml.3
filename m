Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970AbaCRVtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 17:49:19 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:39391 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbaCRVtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 17:49:17 -0400
Date: Tue, 18 Mar 2014 21:49:09 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Teodora Baluta <teobaluta@gmail.com>
Cc: linux-kernel@vger.kernel.org, peter.p.waskiewicz.jr@intel.com
Subject: Re: [RFC] QR encoding for Oops messages
Message-ID: <20140318214909.GA12807@srcf.ucam.org>
References: <1395093587-2583-1-git-send-email-teobaluta@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395093587-2583-1-git-send-email-teobaluta@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 02:59:47PM -0700, Teodora Baluta wrote:

> As far as decoding is concerned, there are a lot of apps on mobile devices
> that decode QR codes (just text mostly). In order to make this work, an
> app which also decodes the QR code is needed. I will be working the next
> couple of weeks on an Android app which scans the Oops encoding QR and
> sends it to a server which keeps track of these Oopses that are sent to
> it making a sort of stream of the latest Oopses. Any thoughts on what the best
> workflow would be are more than welcomed.

When I was thinking about doing this a while ago, my plan was to simply 
encode the oops as a URL - that way existing QR reader software would 
work and there's no need to write a specialised application. I also 
registered the domain kbu.gs to provide the service. Obviously I never 
got around to actually writing the code, so this is great!

-- 
Matthew Garrett | mjg59@srcf.ucam.org
