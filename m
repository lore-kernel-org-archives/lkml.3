Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbaHKFgg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 01:36:36 -0400
Received: from bastet.se.axis.com ([195.60.68.11]:48010 "EHLO
	bastet.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbaHKFgf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 01:36:35 -0400
From: Mikael Starvik <mikael.starvik@axis.com>
To: Maurizio Lombardi <mlombard@redhat.com>,
        Nick Krause <xerofoiify@gmail.com>, Jesper Nilsson <jespern@axis.com>,
        "open@axis.com" <open@axis.com>,
        "list@" <"CRIS PORTlinux-cris-kernel"@axis.com>,
        open list <linux-kernel@vger.kernel.org>
Date: Mon, 11 Aug 2014 07:36:27 +0200
Subject: RE: [PATCH] cris: bug: add unreachable() to silence warnings
Thread-Topic: [PATCH] cris: bug: add unreachable() to silence warnings
Thread-Index: Ac+yEI4K7a9C+2jJRxqVyNiuPT0NiADFZujg
Message-ID: <4BEA3FF3CAA35E408EA55C7BE2E61D0589EBFBC0FE@xmail3.se.axis.com>
References: <1407384076-20060-1-git-send-email-xerofoiify@gmail.com>
 <53E32982.6010409@redhat.com>
In-Reply-To: <53E32982.6010409@redhat.com>
Accept-Language: sv-SE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: sv-SE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Agreed. If you include that, I will ack it

-----Original Message-----
From: Maurizio Lombardi [mailto:mlombard@redhat.com] 
Sent: den 7 augusti 2014 09:24
To: Nick Krause; Mikael Starvik; Jesper Nilsson; open@axis.com; list@; open list
Subject: Re: [PATCH] cris: bug: add unreachable() to silence warnings



On 08/07/2014 06:01 AM, Nick Krause wrote:
>  			      ".previous\n\t"				\
> -			      : : "ri" (__FILE__), "i" (__LINE__))
> +			      : : "ri" (__FILE__), "i" (__LINE__));	\
> +	unreachable();
> +} while (0)

Does this code compile?
There should be a trailing '\' character after "unreachable()".

Regards,
Maurizio Lombardi
