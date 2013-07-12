Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757008Ab3GLGwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 02:52:30 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:59323 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756469Ab3GLGw3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 02:52:29 -0400
Date: Fri, 12 Jul 2013 08:52:27 +0200
From: Heinz Diehl <htd@fancy-poultry.org>
To: linux-kernel@vger.kernel.org
Subject: Re: 3.10.0: Full dynticks = high load
Message-ID: <20130712065227.GC1985@fancy-poultry.org>
References: <krlv29$jbp$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <krlv29$jbp$1@ger.gmane.org>
Organization: private site
OpenPGP: id=60F4A92C; url=http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.21+155 (d3096e8796e7) (2012-12-30)
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V02:K0:BCG2hjdB4ErnEFvvTys6/Sio5HEdW/coye1LZd1GRHM
 PTFIYcxZvauuIBDSUASkSf4qPTDZ6iGO2QJfWlYtZap3HoZuH2
 81W+2JxFo13jI4Nh0uTTjrg8ZB45XCU8xPrGox/xigqcTST/Lq
 +XnwmB1/fPSv9flTvlI4WFIsOozLzJr8Pq4Byunmw7m+MEDX84
 tXSq+gOMIK9Lrnrt0er+/uHa2sde7wMLyiYVxDGtnVrYUTNx3V
 KKYBtKUk9BCV99avcOvltnOMzZTjcTdh0eFdtVnZCOy8Y9m2l3
 LbgFDlp6sn6LqnIY9JGhSBz/FuhdM4aQg8pFGq9rw2+dFK22iQ
 iJ7zSvVJEEbHeX3/ZBS6GVwY3rl0xNl4wPqjCmpEU
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.07.2013, Dâniel Fraga wrote: 

> 	I upgraded to kernel 3.10.0 and decided to try the new "Full
> dynticks system (tickless)" option, but now the system load is always
> at 1 or above.
> 
> 	Using the previous "Idle dynticks system (tickless idle)" solves
> the problem, so it seems the new Full dynticks code is causing this.
> 

This describes exactly what I have encountered, and "tickless idle"
fixed it for me, too. So I'll second that.

