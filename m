Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368Ab3IZKYK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 06:24:10 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:53538 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754851Ab3IZKYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 06:24:09 -0400
Message-ID: <1380191047.25243.4.camel@x220.thuisdomein>
Subject: Re: [PATCH v2] mei: me: downgrade two errors to debug level
From: Paul Bolle <pebolle@tiscali.nl>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>, Adam Jackson <ajax@redhat.com>,
        Joe Perches <joe@perches.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 26 Sep 2013 12:24:07 +0200
In-Reply-To: <CA+i0qc4UZmJ21wCHVERnLAFjO_JgqoQpaMNhRMsnjEKVC9VpVw@mail.gmail.com>
References: <1379013442.11313.5.camel@x220.thuisdomein>
	 <1379014276.11313.9.camel@x220.thuisdomein>
	 <5B8DA87D05A7694D9FA63FD143655C1B1AEC3CE1@HASMSX106.ger.corp.intel.com>
	 <1379585845.1822.7.camel@x220.thuisdomein>
	 <CA+i0qc4UZmJ21wCHVERnLAFjO_JgqoQpaMNhRMsnjEKVC9VpVw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Sep 2013 10:24:07.0459 (UTC) FILETIME=[884DC730:01CEBAA2]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-26 at 11:56 +0300, Tomas Winkler wrote:
> On Thu, Sep 19, 2013 at 1:17 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> > The mei_me driver prints "suspend" at error level at each suspend. It
> > also prints "stop" at error level at driver unload. Downgrade these
> > uninteresting messages to debug level.
> >
> > Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
>>[...]
> 
> Ack

You're the same person as the Tomas Winkler with the intel.com address,
aren't you? If so, you're the maintainer of this code. That makes me
wonder what this Ack is supposed to mean.


Paul Bolle

