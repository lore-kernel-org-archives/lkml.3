Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbaGGNvN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 09:51:13 -0400
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:46022 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753008AbaGGNvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 09:51:12 -0400
Date: Mon, 7 Jul 2014 08:51:08 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Wei Yang <weiyang@linux.vnet.ibm.com>
cc: David Rientjes <rientjes@google.com>, Sasha Levin <sasha.levin@oracle.com>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: mm: slub: invalid memory access in setup_object
In-Reply-To: <20140703124015.GA17431@richard>
Message-ID: <alpine.DEB.2.11.1407070850510.21323@gentwo.org>
References: <53AAFDF7.2010607@oracle.com> <alpine.DEB.2.11.1406251228130.29216@gentwo.org> <alpine.DEB.2.02.1406301500410.13545@chino.kir.corp.google.com> <alpine.DEB.2.11.1407010956470.5353@gentwo.org> <20140702020454.GA6961@richard>
 <alpine.DEB.2.11.1407020918130.17773@gentwo.org> <20140703124015.GA17431@richard>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jul 2014, Wei Yang wrote:

> Here is my refined version, hope this is more friendly to the audience.

Acked-by: Christoph Lameter <cl@linux.com>
