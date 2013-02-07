Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030270Ab3BGA20 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 19:28:26 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:42286 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030253Ab3BGA2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 19:28:22 -0500
Message-ID: <5112F518.3020003@linux.vnet.ibm.com>
Date: Wed, 06 Feb 2013 16:28:08 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Pavel Machek <pavel@denx.de>
CC: Phil Turmel <philip@turmel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        paul.szabo@sydney.edu.au, ben@decadent.org.uk,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: PAE problems was [RFC] Reproducible OOM with just a few sleeps
References: <201302010313.r113DTj3027195@como.maths.usyd.edu.au> <510B46C3.5040505@turmel.org> <20130201102044.GA2801@amd.pavel.ucw.cz> <20130201102545.GA3053@amd.pavel.ucw.cz>
In-Reply-To: <20130201102545.GA3053@amd.pavel.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020700-5806-0000-0000-00001F487C06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2013 02:25 AM, Pavel Machek wrote:
> Ouch, and... IIRC (hpa should know for sure), PAE is neccessary for
> R^X support on x86, thus getting more common, not less. If it does not
> work, that's bad news.

Dare I ask what "R^X" is?

