Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759293AbaJ3LgK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:36:10 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:63183 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758803AbaJ3LgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:36:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Huang Rui <ray.huang@amd.com>
Cc: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Jason Chang <jason.chang@amd.com>, Vincent Wan <vincent.wan@amd.com>,
        Tony Li <tony.li@amd.com>, linux-usb@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v4 01/20] usb: dwc3: enable hibernation if to be supported
Date: Thu, 30 Oct 2014 12:35:56 +0100
Message-ID: <4077930.b7qzaS4pBb@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1414663725-2195-2-git-send-email-ray.huang@amd.com>
References: <1414663725-2195-1-git-send-email-ray.huang@amd.com> <1414663725-2195-2-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:U3taC0nwQBFV5SEBdCcpRqlgDi+TM+hnDUGW+2ZPngg
 rFO6ErZR2eRDZPZ+ClVul6+dN4gSSbHdSVmgpf17SG4qFSifck
 7J/Tis+CvrajlhEKlK3ujtozePU4+xYtveYCFmY3HKWMsgHJu8
 lS0QxuLCfNeMyVZ8wy8FvyhuG8WZ06AuKB54vP8/cMry8l0ksJ
 FgRyohfEy+uUDFdMpBWYziLZWLSL5WDb0Vd6jM44yEf0Ec4y6g
 SOs2IC64TK/RNbgVNsNUNbk0cVustNN82UNpPVFX51L+l8QPgJ
 JtingB7OZUruYeXs19HTmP7OMiik+uJiI3YwiOW9ImhZ0ADEma
 u1gtpqTwYXWxN8/baBio=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 October 2014 18:08:26 Huang Rui wrote:
> It enables hibernation if the function is set in coreConsultant.
> 
> Suggested-by: Felipe Balbi <balbi@ti.com>
> Signed-off-by: Huang Rui <ray.huang@amd.com>
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> 

Something went wrong with the Signed-off-by lines here. 
You should never add someone else's Signed-off-by below yours.

I took a brief look at the entire series and the patches all look good
to me, but you have made the same mistake with the Signed-off-by
multiple times.

	Arnd
