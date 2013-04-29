Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759028Ab3D2Vu4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 17:50:56 -0400
Received: from smtp2.macqel.be ([194.78.208.39]:26063 "EHLO smtp2.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758406Ab3D2Vuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 17:50:55 -0400
Date: Mon, 29 Apr 2013 23:50:52 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: Karel Zak <kzak@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 2/5] Add aix lvm partitions support files
Message-ID: <20130429215051.GA21825@frolo.macqel>
References: <1366924229-21569-1-git-send-email-phdm@macqel.be> <1366924229-21569-3-git-send-email-phdm@macqel.be> <20130429093756.GB12317@x2.net.home> <20130429114041.GA10884@frolo.macqel>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
In-Reply-To: <20130429114041.GA10884@frolo.macqel>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 29, 2013 at 01:40:41PM +0200, Philippe De Muyter wrote:
> On Mon, Apr 29, 2013 at 11:37:56AM +0200, Karel Zak wrote:
> > 
> > Philippe, do you have any disk image with AIX LVM? It would be nice to
> > have a way how to test the code. I'd like to add support for AIX to
> > libblkid too.
> 
> Of course.  But that's not a couple of blocks.  I'll try to cut the
> slice that you need.

Here is one example.  I'll try to send another one tomorrow.

Philippe

--OXfL5xGRrasGEqWY
Content-Type: application/x-bzip
Content-Disposition: attachment; filename="aixlvmhdr-128g.bz2"
Content-Transfer-Encoding: base64

QlpoOTFBWSZTWcspCXEAWyZ////////////////////////////////////5/2iwgsPr4Am/
d4MHoaAAkAxBBAAAAgANNNAaGhoNANA0AGgBoAA0ABoAAAyA0GjQ0AAAAAAAAAAAAaAaGgAS
qpABoaAAAD/9VUAGgaABoANAAAGn/6qoAaAGhiAAAGgaDQAaMgaADQAAAaMQABFU2oJh/qoj
ACYAAABMAmmmAAAAACYQaYAAAAmAAAAAAAAAAEYBMgYEwSqqf/6qqABoAA0AAaAAGmgANAAN
AAAAANAAAAD1NMQAAAAYIAA9QA0AAAIADTTQGhoaDQDQNABoAaAANAAaAAAMgNBo0NAAAAAA
AAAAAAGgGhoACqaUiTIaFPFGNJ6j0hpoeoBoaABk0AxNBkZNHtU3qjTQNGmhn6pGjDUZpNGn
qZGCNAAGj0wmmgAAGhDQyaNDanqbVm6TEymWzGhaJoWXl6Jms1hpcrRzSrxspmstms1ms0Ii
ICICAgICAgICAiJcWEiRHpAvAQLgIAgCAIAgCQIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIi
IiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIkRERERERERERERVUqsBXv2o
Zbt2+vbMGpNEtEVXj2nH13p3xuTvzwDwT5tfOORPnnJH0D6J9I5M5QyHKn0z6hyx9U+scucw
cyc0a8+ufYObOcNgc6fZOePtH2znz7hsT7p0B0J94++dEdGdIdKdMfgPwnTn4j8Y4YcQOKHG
DjhyA5IcoJAOWHMCRCSDmhzg54dA2ZtDam2OqNudWbg6w60644k687A7E7I7M7Q7U7Y7c7g7
k7o7s7w7074+Qbk788A/edQfwP4myOpORNmbQ2ptjqjbnVm4OsOtOuOvOwOxOyOzNedodqds
dudwdyd0d2d4d6eYPOHoD0h65XZwIERXeVLyBtzuGqE7p3zwHjIJBIJMSaSo/Zc5m2NFU6eK
q22tupWtSqVVacgU6a7VVfphmRShvMegiqpaKqq/JGrqFVTUxR5BAqqKqvC0Ov/OpWYUiqqq
Gqgq0UbhKKpRjVKYLuquUqoh+5GpQUFBpsWO92/UxQxqoKY0VTpHPtgwUKoxIb7FVWYwRERE
RERERERERERERERZa12tERERdrREREXa0RERF2tERERERFrWiIiJUktMvC6iIiIiIiIiIiIi
IiIiIiIjBa0RERERERERbzGDBERGFrREREXa1rWiIiIiIiIiIiIiIi6taIiIiIiIiERERERE
RERERERERERERERERERERERERESIjMWtERERha12tEREREREREREREREREREREY7Wu1oiIiE
MKoCgtKkiFYIpRBUBQ4phcwCSSqtVVbSMbBSqqjEgbxvfr2FVVUNLKrwoUVTR6G1UqqoGybO
vDwxexy2jDFEVapijZLqhRcklRGE0hRRCqwQIVWNB6R3CzESsTG35sm0bRq2mdS2batM2rUt
s1bqm3dW3DrHWqYdosR2yqEodw7p3jvloPAeE8R4yqigBCEIQhCEIQhCEIQhCEIQhCEIQhCE
IQhCPIeU8x5z0HpPUeshiFLWQxcC7l4PYXk9p7j3v6PCf1cC/syMjIyMjIyMjIyMjI90yMjh
2R75kZ7IyMjIyMjIyMjIyMjIzmuVrkGdSqkmcsVaiKgipcqqokUpVWQgoplIpRWcrjGIwylR
EFXEpFV4iKWKiKIimBFLca3plN7MTdZQpRaVOCBJ2MYxkCMYxjGMYxjGMYxjGMYxjGMYxjGK
AEIQhCEIQhCEIQhCEIQhCEIQhCEIQhCEIYxjGMYxjGMYxjGMYxjGMYxjGMYxjGMYxl6GXwYx
jGNns9ns9ns9ns98Rns9rla5FGcri3EHwWIxKh/LPymUMQxmDAwGDBgYC1mDAZzjWDKqGU9Z
oKwaAhCUMTAUKwGPx8UYhVGIatXBLGNx/PZWjYxxeCxoiCKqqoeM5xgOOaNqGUqMQeKgwgSC
cZxGA2LyljyT4djk4JBwDMLH+aqDhWqsYugT3ZgG7Qb/UFMSFeMWsiFaZCr6lw5gcu8EiLYO
bRZa2/GBghoLb9gYV6Xb3TGxEQtC0LIRVWsN8Q0rw7GOkNQsshDgllnJuhYGBwbVMDAynKsD
A1DSMDAhCEIQhDf1nqmBZD/dWWhEpCEbr3Nt1zE5ni9PvXj6E9QzCyEOGWXSG+WWe3WWefWW
SkIQhCEJSEIQh5blsDBsUWQ8QxsFYEHOhByCHikcCQ+EZyHebmzEawg3fFFm8U56JRpHUWoy
QFbuKCY1ArQuOLoFZY/4QeI1ixp3/ljXoNBVZi1K4NCvToPmRVPqJVU5aoHmUHRpVUa9D5SF
MuFU10KprWwc01piVXBuzWMtFU07W2OhhiedsO7QreHO2o9m5+zkkDiY4RrKq9QkRqjwK/uw
2DsrbzFbHWW4mKpVVQN5VVVTzjcuEOEcKlejVwtqcMgcoiuich7TisOAdLu9P/8XckU4UJDL
KQlx

--OXfL5xGRrasGEqWY--
