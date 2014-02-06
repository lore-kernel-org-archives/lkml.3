Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932620AbaBFNjM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 08:39:12 -0500
Received: from mail-yh0-f46.google.com ([209.85.213.46]:37489 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756241AbaBFNjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 08:39:11 -0500
Date: Thu, 6 Feb 2014 10:38:57 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Namhyung Kim <namhyung@kernel.org>, linux-kernel@vger.kernel.org,
        Chad Paradis <chad.paradis@umit.maine.edu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [patch] perf tools: perf list broken on ARM
Message-ID: <20140206133857.GA8026@ghostprotocols.net>
References: <alpine.DEB.2.10.1312301536150.28814@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1401081629200.4410@vincent-weaver-1.um.maine.edu>
 <871u0hd0x4.fsf@sejong.aot.lge.com>
 <20140109121206.GA30069@ghostprotocols.net>
 <1389271023.1722.4.camel@leonhard>
 <20140109124845.GB30069@ghostprotocols.net>
 <alpine.DEB.2.10.1402051532250.14738@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1402051532250.14738@vincent-weaver-1.um.maine.edu>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Feb 05, 2014 at 03:34:42PM -0500, Vince Weaver escreveu:
> > You are right, I saw that Author: line in the changeset comment, close
> > to the start of the message and got confused, thanks for clarifying.
> 
> Do I need to re-send this patch?  It still applies cleanly to 3.14-rc1.

Sorry, picked it up now, will send it to Ingo today.

- Arnaldo
