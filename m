Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbaCFQnX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 11:43:23 -0500
Received: from p3plex2out02.prod.phx3.secureserver.net ([184.168.131.14]:33304
	"EHLO p3plex2out02.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751695AbaCFQnW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 11:43:22 -0500
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Fred Akers <knivey@botops.net>, "greg@kroah.com" <greg@kroah.com>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 1/2] Staging: comedi: range: tidy up
 comedi_check_chanlist()
Thread-Topic: [PATCH v2 1/2] Staging: comedi: range: tidy up
 comedi_check_chanlist()
Thread-Index: AQHPOQlWs6T6ox3k+EKbxspwZf6EQJrUQ9vQ
Date: Thu, 6 Mar 2014 16:43:21 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825DA4031@P3PWEX4MB008.ex4.secureserver.net>
References: <20140306062333.GA19862@kroah.com>
 <1394089039-12408-1-git-send-email-knivey@botops.net>
In-Reply-To: <1394089039-12408-1-git-send-email-knivey@botops.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [184.183.19.121]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 05, 2014 11:57 PM, Fred Akers wrote:
>
> Refactor this function to remove an extra indent level
>
> Signed-off-by: Fred Akers <knivey@botops.net>

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

Thanks
