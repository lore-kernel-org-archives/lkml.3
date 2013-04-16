Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab3DPHOv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 03:14:51 -0400
Received: from gate.crashing.org ([63.228.1.57]:55166 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752737Ab3DPHOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 03:14:50 -0400
Message-ID: <1366096475.24994.50.camel@pasglop>
Subject: Re: [PATCH 4/8] Read/Write oops nvram partition via pstore
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: Michael Ellerman <michael@ellerman.id.au>, linuxppc-dev@ozlabs.org,
        paulus@samba.org, linux-kernel@vger.kernel.org,
        jkenisto@linux.vnet.ibm.com, mahesh@linux.vnet.ibm.com,
        anton@samba.org
Date: Tue, 16 Apr 2013 09:14:35 +0200
In-Reply-To: <516CEDB4.9090005@linux.vnet.ibm.com>
References: <20130410071835.20150.56489.stgit@aruna-ThinkPad-T420>
	 <20130410072303.20150.61382.stgit@aruna-ThinkPad-T420>
	 <20130415075555.GE30156@concordia> <516CEDB4.9090005@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-16 at 11:50 +0530, Aruna Balakrishnaiah wrote:
> 
> Sure. I will have one #ifdef for declarations and one for function
> definitions.

Declarations generally don't need #ifdef's

Cheers,
Ben.
 

