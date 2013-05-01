Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab3EAFgB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 01:36:01 -0400
Received: from smtp2.macqel.be ([194.78.208.39]:13415 "EHLO smtp2.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342Ab3EAFfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 01:35:54 -0400
Date: Wed, 1 May 2013 07:35:50 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: Karel Zak <kzak@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 2/5] Add aix lvm partitions support files
Message-ID: <20130501053550.GA32026@frolo.macqel>
References: <1366924229-21569-1-git-send-email-phdm@macqel.be> <1366924229-21569-3-git-send-email-phdm@macqel.be> <20130429093756.GB12317@x2.net.home> <20130429114041.GA10884@frolo.macqel> <20130429215051.GA21825@frolo.macqel> <20130430070840.GA4046@frolo.macqel> <20130430071840.GA5165@frolo.macqel>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
In-Reply-To: <20130430071840.GA5165@frolo.macqel>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 30, 2013 at 09:18:40AM +0200, Philippe De Muyter wrote:
> On Tue, Apr 30, 2013 at 09:08:40AM +0200, Philippe De Muyter wrote:
> > On Mon, Apr 29, 2013 at 11:50:51PM +0200, Philippe De Muyter wrote:
> > > On Mon, Apr 29, 2013 at 01:40:41PM +0200, Philippe De Muyter wrote:
> > > > On Mon, Apr 29, 2013 at 11:37:56AM +0200, Karel Zak wrote:
> > > > > 
> > > > > Philippe, do you have any disk image with AIX LVM? It would be nice to
> > > > > have a way how to test the code. I'd like to add support for AIX to
> > > > > libblkid too.
> > > > 
> > > > Of course.  But that's not a couple of blocks.  I'll try to cut the
> > > > slice that you need.
> > > 
> > > Here is one example.  I'll try to send another one tomorrow.
> > 
> > Here is the other example.
> 
> And here is a third one

And now a fourth one, this one with partitions that are not contiguous.

Philippe

-- 
Philippe De Muyter +32 2 6101532 Macq SA rue de l'Aeronef 2 B-1140 Bruxelles

--gKMricLos+KVdGMg
Content-Type: application/x-bzip
Content-Disposition: attachment; filename="aixlvmhdr-136g.bz2"
Content-Transfer-Encoding: base64

QlpoOTFBWSZTWW5aaa0AdN5/////////////////////////////////////////////4BN/
OSF4kLgpIQKAaoUAAAAAMHhDCBhDAAAAAAqqpKe1TabyqaeoH/6qoAeoAAAAAHqaGjQAAD9S
AAADJpoNAAAeUDIAPUxo0INpkTf/6qqn//qqqMAAAYAAUAGgNAJVVTTAJgAACYmAAARgEwEw
AAH/5VUJgABGAAJgAAAAJkwmCYAPU/VAAAAAAAEwAAEqqj//VVQAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAJVVP/9VVAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB
JgAJgACYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABVMqREPUp6o2KbQammZIGTQAaBo
aaGgNAYQAyADIyGRkGTagPUBtTQzU/U/1UTAmAT1Gjf6qntITTQaAAGIaZAzIGj/1UNQ1P3F
bHE43IclyHJbm52pscpo2O1Nzjbm5ubnMbm5ubm5ubm5ubm5ubm5zG5uclxNGjRo0aKRERER
ERERERERERERERERERERERERERERKqqqqiqqqqqqqqqqqqqqqqqqqiqqqqqqqpERERERERER
ERERERERERERERERERERERERERERERERERERERERERERERERERERERERKqqqqqqqqqqqqqIi
IREREREREREREREREREREREREREREREREREREREREREREREREREiIiIiIiIiI0qoiIiIiIiI
i1UREREREREREIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiI
iIiIiIiJERERmMzGxmPAuhd0dW6A98zk8ty0Rmc/1hrzYGxNkbM2hwR7w4M96cIe+PfnwD4J
wp8I+GfEPqH1T6x9c+wcMcOfZPtH2z7h90+8ffPwH4T8Rpz8ZxBxJxRqDizjDUnGnKnLHLnM
HMnNHNnOHOnPHPnQHQnRHRnSHSnTHTnUHUmtNca82BsTZGzNobU2xtzcG5N0bs3h7I9mdcde
e0Pantj257g7A9ye6NTsTsjsznnqTqz/h/0/8a01xrzYGxNkbM2htTbG3Nwbk3RuzeH7D9p+
4/efwP4n8j+Z/Q/qdUf2NT807E6g7I7M557s94e9O0P0T9I5p1J1JzTmnNPJnNPJm83nlDyp
+yeUPLHlzzB5k80cQcScUag4s4w1Jxpxxx5+Q44/KfmPznIGqORNWaw5I5M/QcoQ/SU/UfrO
VOWOXOYOZOaObOcOdOeOfOgOhOiOjOkOlOmOnOoOpNaa415sDYmyNmbQ2ptjbm4Nybo3Zuje
Hsj2Z1x157Q9qe2PbnuDsD3J7o1OxOyOzOee7PeHvTtDU1NTU1NTU1NTU1NTU3m83m83m83m
83m83m83m83m83mpqampqampqampqampqampqampqampqampqanA4HA4HA4HA4HA4HA4HA4H
A4HA4HA4HA4H9zkjV6vQ7zP6xnldVqNA640LrJ5ppmmaVpX0X02laZvTRVymHcJjO+tH2OjG
ZjmEzVMHGgY2TMzNiZmZmcuGIgxjGZm1o7QZ6cIzMMYiGedTDMYxoRmaJYyzMxFZUdarlI3I
bUNrIjJgYwFeSekXY2MxmYxoqskOtjHg3G+laMGYxtQfATMHIRERoiIiIiIiIiqqIiIioqIi
IrpNGiIiIiIiIjRVVVREREREREIiIiIiIiIiIiIiIiJERERFVURERERERERCIiIiIiIiIiIi
IiIiRERyVVERERoqoilVERFVURERERERERERERERFVURERFVURERERERERERERURERUUiIiK
RERERERERERERERESIiIiIiIi1URERERaq4zMMBVREREQilmZUMFVUGQKqmVVMqqZVUyqplV
TKqmVVMqqZVUyqplVTKqmVVMqqZVUyqplVTKqmVVMqqZVUyqplVTKqmVVMqqZVUyqplVTKqm
VVMqqZVUyqplVTKqmVVFVRVUVVFVRVUVVFVRVUVVFVRVUVVFVRVUVVFVRVUVVFVRVUVVFVRV
UVVwqqKqiqoqrhVUVVFVRVUVVFVRVUVVFVRVUVVFVRVUVVFVRVUVVFVRVUVVFVRVUVVFVRVU
VVFVRVUVVFVRVUqqVVKqlVSqpVUqqVVKqndGjRoVVKqlVSqpVUqqVVKqlVSqpVUqqVVKqlVS
qpVUqqVVKqlVSqpVUqqVVKqlVSqpVUqqVVKqlVSqpVUqqVVKqlVSqpVUqqVVKqlVSqpVUqqV
VKqlVSqpVUqqVVKqlVSqpVUqqVVKqlVSqpVUqqVVKqlVSqpVUqqVVKqlVSqpVUqqVVKqlVSq
pGMgzmIyo7HyDx+nj+One+ZxcbZnTtOo0DMxjlJmHbmisx5EmAMwdE7sVxByylQivOGlZiO3
c5ozMDREhmZmOipTMzGN6Vo3c3dVZG+KrfGRkZGRkZGRkZGRkVVV11ms1ms1mqqqqu4Kqu5K
qqrtiqqqwwwwwwwwwwwwwwwwwwwwwwqqqqrxDfm+vFt+b68e8gryKqrw6qrSKqt/eMb+qqqq
ryiqqqrziqqAgICAgICAgICAgJOIQhCEIQhCEIQhCEIQhCEIQhCEIQhCEIQhCEIQhCEIQhCE
IQhCEIQhCEIQhCEIQhCEIQhCEIQhGczmczmczmczlVVVVVXsVVVVwiuDVVVVVVVXCqqqqq+Y
qqqqqqqqqqqq4dVVVVVVVVVVVVVVVVyKtYrVq1itYqutdYM5zMIc5B9e8i2tG3MHOSMGMQZT
EEIwgyMwY7s/JeEaGGD0sZmZ1UZmGD0rjK5ZSmJCZjGEZnPQVjMzEQZCGZGimV6l6Y0+p3tq
jQMw3tomgREaJoURGVlZWVlZWVlZWVlZUR1tEZrNZrNZqIiIjsSIiIiNGiIiI7wwwwwwwwww
wwwwwwwwwwwww7oiIiIiIiIiIiIjxKIiIiI0jM0jPMyIiIiIiIiIiI88iIiIiIiPVO0tG4Bw
BjGMYxjGMYxjGMYxjGMYxjGMYxjGMYxjGMYxjGMYxjGMYxjGMYxjGMYxjGMYxjGMYxjGMYxj
GMYxjGMhEIhEIhEIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIjhkRERERERERERERERERERER
EREcmzOUOQcedYzM+Z40+qZ9mZ8jPA//NnG4xxZxEyGQ0aGhohkaNDQKpTTIyRnVK5yM2tpt
OLYrIRkZnntraMGbAhmYQONDrEM/dNgzMzFBxxiEZBmYYgQ6x1rQ0KlM7JaGJ1foNA/fRmyH
SIyxk99UKgJ5nKUhniXscKGiBGw9AaMZpGY+bOnU5hGYxsRmSHZ5lUyEA+zQRDyyDwY0dM0N
jw6jYhWjpDQzRBxwruO1oNn7bvy40OJBUKgqBUFPhHQtDNGZsUzO8EPWoZj0k6WYxxHqVGdS
/zLjPhUxn6jyCmbUM8u7k8x/d6t0fUcZh0SDOnQ6DYpj2LyTFA6pDHdYOCHbP11M7ugzpj65
Rh8D/JRlQcaGPHBAeaPOId/Q42wzOYQ9+x6uJhXfaw7bAZ18YE2sBnIedPw2mAzkBzCCEEII
Q/QQ9MNCiEO8oUghBtw5DQ0EIIyCEEIIQQghBCCEPKvWNHx+wvoYUQghBCCEEIIQRkIhCCEH
cFKIQQghBCCEHeClEIO3qUQghBCCEEIIQQjOvRSHHCkEIIQQgjIIQQghBCCEEIIQbSlEIIQf
sUo82UohBCCEEIIQQghB86pSwpB3x0poaH1KFVCiEPmEO+NCiEO8odW+WdW2s2CEIQhBCCEZ
EdGp852/ptDrocp0LsNDM/lhn+sSMx0qH0CCQx8hhGD3/Mh4pAdAgcSHRkMd3TMZmMB0DMzM
QPlx0jxz/8XckU4UJBuWmmtA

--gKMricLos+KVdGMg--
