Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030640AbaGROXa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 10:23:30 -0400
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:37309 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030558AbaGROX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 10:23:26 -0400
Date: Fri, 18 Jul 2014 09:23:24 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Pranith Kumar <bobby.prani@gmail.com>
cc: rdunlap@infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] doc: Add remote CPU access details and others to
 this_cpu_ops.txt
In-Reply-To: <53C85FE9.6010304@gmail.com>
Message-ID: <alpine.DEB.2.11.1407180922110.28503@gentwo.org>
References: <1405552141-8506-1-git-send-email-bobby.prani@gmail.com> <alpine.DEB.2.11.1407170848490.27584@gentwo.org> <53C7D93B.4090006@gmail.com> <alpine.DEB.2.11.1407170934220.28121@gentwo.org> <53C7E234.3020503@gmail.com> <alpine.DEB.2.11.1407171005450.28248@gentwo.org>
 <53C85FE9.6010304@gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2014, Pranith Kumar wrote:

> > then we have on x86 a increment operation with locked semantics racing
> > with an unlocked one on the same cacheline.
> OK, I will add this as a warning in the documentation. Thanks!

Note that I have not been able to get beyond a bad feeling. Looked up
various sources of information about how the lock prefix works. Still I am
not sure if this works or not.


