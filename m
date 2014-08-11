Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858AbaHKTkF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 15:40:05 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:46600 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825AbaHKTkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 15:40:03 -0400
Message-ID: <53E91C10.3060707@infradead.org>
Date: Mon, 11 Aug 2014 12:40:00 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Nick Krause <xerofoify@gmail.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        lisa@xenapiadmin.com, Ben Hutchings <ben@decadent.org.uk>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: Check against NULL in fw_download_code
References: <1407780151-4674-1-git-send-email-xerofoify@gmail.com>	<CAPDOMVghgyQ72J6MS6uaWEeMFBvzDNmfoAS5Tbd7+XO_KgUmHg@mail.gmail.com>	<53E9066A.3030801@infradead.org>	<CAPDOMViHWMRRMqdEpjft0TDuVSLai8LuWRcXPdMeCtUYgB2sgw@mail.gmail.com>	<53E90F34.9030809@infradead.org>	<CAPDOMVj0YcDc5ATxMiTLeciadJPiQxV2ap8Wo3Qg4RM=yeXmVQ@mail.gmail.com>	<53E913C6.4040800@infradead.org> <CAPDOMVgChPhOfBdMAjQTJKmw5+LFO_7GoYU8A5ttDHMYHYY0fA@mail.gmail.com>
In-Reply-To: <CAPDOMVgChPhOfBdMAjQTJKmw5+LFO_7GoYU8A5ttDHMYHYY0fA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/14 12:18, Nick Krause wrote:
> 
> Thanks Randy for your help otherwise is my patch good? Please let me
> known if there our any other issues.
> Regards Nick

I didn't notice any other issues with it.

-- 
~Randy
