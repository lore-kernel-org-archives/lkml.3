Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751273Ab3CWNPA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 09:15:00 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:62159 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751057Ab3CWNOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 09:14:49 -0400
Message-ID: <1364044486.1390.237.camel@x61.thuisdomein>
Subject: Re: [PATCH 21/21] cris: drop unused Kconfig symbols
From: Paul Bolle <pebolle@tiscali.nl>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
        Mikael Starvik <starvik@axis.com>,
        linux-cris-kernel <linux-cris-kernel@axis.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sat, 23 Mar 2013 14:14:46 +0100
In-Reply-To: <20111031105959.GA26898@axis.com>
References: <1318595467.6132.80.camel@x61.thuisdomein>
	 <20111014133354.GE9412@axis.com> <14215.1318619461@turing-police.cc.vt.edu>
	 <20111031105959.GA26898@axis.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Mar 2013 13:14:47.0180 (UTC) FILETIME=[6467F4C0:01CE27C8]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper,

On Mon, 2011-10-31 at 11:59 +0100, Jesper Nilsson wrote:
> Ok, let's do it the right way and remove them now, and I can re-add
> them in the same tree.

The patch at the start of this (old) thread still applies on top of
v3.9-rc3. Do you still intend to remove the cris Kconfig symbols unused
in mainline?

(Note that there's a second order effect to this patch:
ETRAX_ETHERNET_IFACE0, and ETRAX_ETHERNET_IFACE1, and ETRAX_SERIAL_PORT4
could also be dropped. I'm happy to submit a patch with those included
too.)


Paul Bolle

