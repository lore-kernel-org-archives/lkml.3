Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262Ab3DPH7x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 03:59:53 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:36159 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817Ab3DPH7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 03:59:52 -0400
Message-ID: <516D04EF.6030803@linux.vnet.ibm.com>
Date: Tue, 16 Apr 2013 13:29:43 +0530
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Michael Ellerman <michael@ellerman.id.au>, linuxppc-dev@ozlabs.org,
        paulus@samba.org, linux-kernel@vger.kernel.org,
        jkenisto@linux.vnet.ibm.com, mahesh@linux.vnet.ibm.com,
        anton@samba.org
Subject: Re: [PATCH 4/8] Read/Write oops nvram partition via pstore
References: <20130410071835.20150.56489.stgit@aruna-ThinkPad-T420> <20130410072303.20150.61382.stgit@aruna-ThinkPad-T420> <20130415075555.GE30156@concordia> <516CEDB4.9090005@linux.vnet.ibm.com> <1366096475.24994.50.camel@pasglop>
In-Reply-To: <1366096475.24994.50.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041607-2000-0000-0000-00000BBFB2D9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 April 2013 12:44 PM, Benjamin Herrenschmidt wrote:
> On Tue, 2013-04-16 at 11:50 +0530, Aruna Balakrishnaiah wrote:
>> Sure. I will have one #ifdef for declarations and one for function
>> definitions.
> Declarations generally don't need #ifdef's

Sorry by declarations I meant variable declarations (used by pstore) not function
declarations.

> Cheers,
> Ben.
>
>

