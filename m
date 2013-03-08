Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934581Ab3CHSLQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 13:11:16 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:30996 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759949Ab3CHSLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 13:11:15 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlkFAIMpOlFbdWObgWdsb2JhbABDvGQih0iBWxYOAQEWJiiCLQEFJ1EBEAshFg8JAwIBAgFFBg0BBwEBiBO7Ho8MB4NAA5ZTk30
X-IPAS-Result: AlkFAIMpOlFbdWObgWdsb2JhbABDvGQih0iBWxYOAQEWJiiCLQEFJ1EBEAshFg8JAwIBAgFFBg0BBwEBiBO7Ho8MB4NAA5ZTk30
X-IronPort-AV: E=Sophos;i="4.84,809,1355094000"; 
   d="scan'208";a="8779980"
Message-ID: <513A29B6.2040807@igalia.com>
Date: Fri, 08 Mar 2013 19:11:02 +0100
From: =?ISO-8859-1?Q?Samuel_Iglesias_Gons=E1lvez?= <siglesias@igalia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: industrypack-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Jens Taprogge <jens.taprogge@taprogge.org>
Subject: Re: [PATCH 1/3] ipack: avoid double free on device->id
References: <512DCB33.6030500@igalia.com> <1362730907-10047-1-git-send-email-siglesias@igalia.com> <20130308174701.GA13276@kroah.com>
In-Reply-To: <20130308174701.GA13276@kroah.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On 03/08/2013 06:47 PM, Greg Kroah-Hartman wrote:


Yes, you are right. It's not possible to have it freed twice once it's
in ipack_device_release().

You can skip this patch. If you want, I can resend the others accordingly.

Sam

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBCAAGBQJROim2AAoJEH/0ujLxfcND8ksQAIKZJlIONv1h6FWQEzcOrptA
ReEB0p+uDQfRzjpbqzeZcXa3vVK6sc2nIUTggdQcnfNcse38Jn4JCKGllAQfZE51
71ANDmhUpmALKD1o0A8Cya85IfnaVQBhHcmA2b3/wh5dgXjcvgjHWZDjduEC3+I7
sIikZ+OYAZa69dfXYN+NgVYCTj5Gk+eA9oWdnV17d18bviqVf1/PdHHGMceMke9p
jW/UY4mxPHGkJdtZ8RV0avm2VAwY0/HOtzjI8JXZ7Nve9HIYhEcMyBrpHxOQI6U3
CBPY5kqlOa2MdGTiKQct7Daeeqm1guSPPJDRRI3y0O+qgHOn4a8eTVHQ21WMHJoP
Yq1RterlGzRGGzv8s9k76600gXqbaQreEN96fXxISDtk57N/ffIn0cuZwbaeTLpa
AfvV0PeuBpwJ5SezQryNx2O708tk8FGiCys3yAFcak82Am4xBsgIrEo1UYIYXonC
rGbmuG36yxsktMdklz5+ys7R4pDW8Un0iCOMmO3etrYDepy6n9vfjXmYWc8MK2D6
WaVj01qadSj8iHE1cFZms6LnQ+VETc9256QkkFMWaNApW9+BhnGIRj8DErbgOfKK
k1BfmNUrPyuFIlxPxy6kkPwPGfLUOP9yRhGmzrJ18DWJJtdELan5RQIrMlH21LA2
ajvtF3Pt5eDhDy9gM6A8
=LI+5
-----END PGP SIGNATURE-----
